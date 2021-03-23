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

Declarations2 = application:get_env(cctv, publish_declarations),
        {_, Dcls2} = Declarations2,


    A = [#{id => my_publisher,
	   start => {turtle_publisher , 
		     start_link ,[my_publisher,amqp_server,Dcls2,
		     #{confirms => false}]},
           restart => permanent,
	   shutdown => 5000,
	   type => worker,
           module => [turtle_publisher]}],

%io:format("the AMQPPoolChildSpec in publish ~p ~n",[A]),

    {ok, {{one_for_one, 3, 10}, A}}.
