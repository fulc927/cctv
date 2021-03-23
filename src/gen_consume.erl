-module(gen_consume).
-behaviour(gen_server).
-export([start_link/0]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
terminate/2, code_change/3]).
-include_lib("amqp_client/include/amqp_client.hrl").
 
start_link() ->
gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
	
%% Note we must set trap_exit = true if we
%% want terminate/2 to be called when the application
%% is stopped
process_flag(trap_exit, true),
%io:format("Gen_consume is ~p starting~n",[?MODULE]),

Self = self(),
	F = fun(Key, ContentType, Payload, Header, _State) ->
		io:format("Key ~p ~n",[Key]),
		io:format("Header ~p ~n",[Header]),
		io:format("Contentype ~p ~n",[ContentType]),
		io:format("Payload ~p ~n",[Payload]),
		Self ! {Key, ContentType, Payload},
		ack
	end,
InitState = #{},
Declarations = application:get_env(cctv, consume_declarations),
     {_, Dcls} = Declarations,
Amqp = #{
  name => local_service,
  connection => amqp_server,
  function => F,
  %function => fun _Mod:loop/4,
  handle_info => fun gen_consume:handle_info/2,
  init_state => InitState,
  subscriber_count => 1,
  prefetch_count => 1,
  passive => true,
  consume_queue => <<"incoming_seb">>,
  declarations => Dcls
		  
       },
%io:format("the AMQPPoolChildSpec in consume ~p ~n",[Amqp]),
{ok, _ServicePid} = turtle_service:start_link(Amqp),

{ok, 0}.

handle_call({pub, Thing}, _From, N) -> 	{reply, ok, N+1}.

handle_cast({pub2, Thing2}, N) -> {noreply, N}.

handle_info(_Info, N) -> 
	io:format("gen_consume handle_info N ~p ~n",[N]),
	{noreply, N}.

terminate(_Reason, _N) ->
io:format("~p stopping~n",[?MODULE]),
ok.

code_change(_OldVsn, N, _Extra) -> {ok, N}.

%default_service_config(#{} = Override) ->
%    HandleFun = fun(_Key, _ContentType, _Payload, _State) ->
%    io:format("~p Key ~n",[_Key]),
%    io:format("~p Contenttype ~n",[_ContentType]),
%                               ack
%                       end,
%    HandleInfo = fun(_Info, State) ->
%                                {ok, State}
%                        end,
%    InitState = #{},
%    Config = #{
%            name => local_service,
%            connection => amqp_server,
%            function => HandleFun,
%            %handle_info => HandleInfo,
%            init_state => InitState,
%            declarations => [],
%            subscriber_count => 1,
%            prefetch_count => 10,
%            consume_queue => <<"placeholder">>
%        },

%    maps:merge(Config, Override).
