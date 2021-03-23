-module(rmqc).
-export([gen_publish/0]).
-include_lib("amqp_client/include/amqp_client.hrl").

%%% Exemple de publisher avec confirms (mode transactionnel very heavyweight) decrease throughput by a factor of 250
gen_publish() ->
Declarations = application:get_env(cctv, rmqc_declarations),
        io:format("~p ~n",[Declarations]),
        {_, Dcls} = Declarations,
        io:format("~p ~n",[Dcls]),
	turtle_publisher:start_link(my_publisher,
				    amqp_server,
				    Dcls,
				    #{ confirms => true} ),
       				    ok.



