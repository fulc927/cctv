%%%-------------------------------------------------------------------
%% @doc joearmstrong public API
%% @end
%%%-------------------------------------------------------------------

-module(cctv_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    joearmstrong_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
