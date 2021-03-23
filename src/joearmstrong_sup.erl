%%%-------------------------------------------------------------------
%% @doc joearmstrong top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(joearmstrong_sup).

-behaviour(supervisor).

%-export([start/0,start_in_shell_for_testing/0]).

-export([start_link/0]).

-export([init/1]).

-include_lib("amqp_client/include/amqp_client.hrl").

-define(SERVER, ?MODULE).

%start() ->
%	spawn(fun() -> supervisor:start_link({local,?SERVER}, ?MODULE, _Arg = [])end).
%start_in_shell_for_testing() -> 
%	{ok, Pid} = supervisor:start_link({local,?SERVER}, ?MODULE, _Arg = []), unlink(Pid).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    %% AMQP Publisher
    %Exch = <<"email-out">>,
    %PublisherName = my_publisher,
    %ConnName = amqp_server, %% As given above
    %AMQPDecls = [
    %#'exchange.declare' { exchange = <<"email-out">>, type = <<"topic">>}, #'queue.declare' { queue = <<"outgoing_email">>}, #'queue.bind' { queue = <<"outgoing_email">>, exchange = <<"email-out">>, routing_key = <<"seb@otp.fr.eu.org">> }
    %],
    %AMQPPoolChildSpec = turtle_publisher:child_spec(PublisherName, ConnName, AMQPDecls,#{ confirms => false, passive => false }),

	{ok, {{one_for_one, 3, 10},
		[
		{tag1,
		{gen_consume, start_link, []},
		permanent,
		10000,
		worker,
		[gen_consume]},
		{tag2,
		{pub_sup, start_link, []},
		permanent,
		10000,
		supervisor,
		[pub_sub]},
	        {tag3,
		{uploader, start_link, []},
		permanent,
		10000,
		worker,
		[uploader]}]}}.

%% internal functions
