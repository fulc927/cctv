-module(rmqc).
-export([gen_publish/0]).
-include_lib("amqp_client/include/amqp_client.hrl").

gen_publish() ->
	turtle_publisher:start_link(my_publisher,amqp_server,[#'exchange.declare' { exchange = <<"email-out">>, type = <<"topic">>}, #'queue.declare' { queue = <<"outgoing_email">>}, #'queue.bind' { queue = <<"outgoing_email">>, exchange = <<"email-out">>, routing_key = <<"seb@otp.fr.eu.org">> }],#{ confirms => true} ), ok.



