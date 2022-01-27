%%%-------------------------------------------------------------------
%% @doc draft_example top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(draft_example_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    Port = application:get_env(draft_example, http_port, 8080),
    Host = application:get_env(draft_example, http_host, 0.0.0.0),
    ElliOpts = [{callback, draft_example_handler}, {port, Port}, {host, Host}],

    ElliSpec = #{id => draft_example_server,
                 start => {elli, start_link, [ElliOpts]},
                 restart => permanent,
                 shutdown => 5000,
                 type => worker,
                 modules => [elli]},
    SupFlags = #{strategy => one_for_one,
                 intensity => 5,
                 period => 10},

    {ok, {SupFlags, [ElliSpec]}}.
