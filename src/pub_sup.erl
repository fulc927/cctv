%
% This Source Code Form is subject to the terms of the Mozilla Public
% License, v. 2.0. If a copy of the MPL was not distributed with this
% file, You can obtain one at http://mozilla.org/MPL/2.0/.
%
% Copyright (C) 2014 Petr Gotthard <petr.gotthard@centrum.cz>
%

-module(pub_sup).
-behaviour(supervisor).
-include_lib("amqp_client/include/amqp_client.hrl").
-export([start_link/0, init/1]).
-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->


%AMQPPoolChildSpec = turtle_publisher:child_spec(Type, ConnName, AMQPDecls, #{ confirms =>false}),
%                  supervisor:start_child(turtle_sup, AMQPPoolChildSpec),


    A = [#{id => my_publisher,
	   start => {turtle_publisher , start_link ,[my_publisher,
						     amqp_server,
						     [{'exchange.declare',0,<<"email-out">>,<<"topic">>,false,false,false,false,false,[]},{'queue.declare',0,<<"outgoing_email">>,true,false,false,false,false,[]},{'queue.bind',0,<<"outgoing_email">>, <<"email-out">>, <<"sebastien.brice@opentelecom.fr">>,false, []}],
						     #{confirms => false}]},
           restart => permanent,
	   shutdown => 5000,
	   type => worker,
           module => [turtle_publisher]}],

io:format("le AMQPPoolChildSpec ~p ~n",[A]),

    {ok, {{one_for_one, 3, 10}, A}}.
