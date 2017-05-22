%%%-------------------------------------------------------------------
%% @doc catalog public API
%% @end
%%%-------------------------------------------------------------------

-module(catalog).

-behaviour(application).

%% Application callbacks
-export([start/0]).
-export([start/2]).
-export([stop/0]).
-export([stop/1]).
-export([start_phase/3]).


%%====================================================================
%% API
%%====================================================================

%% application
%% @doc Starts the application
-spec start() -> ok.
start() ->
    {ok, _} = application:ensure_all_started(catalog),
    ok.

%% @doc Stops the application
stop() ->
    ok = application:stop(catalog),
    ok.

%% behaviour
%% @private
start(_StartType, _StartArgs) ->
    catalog_sup:start_link().

%% @private
stop(_State) ->
    ok = cowboy:stop_listener(catalog_http).

-spec start_phase(atom(), application:start_type(), []) -> ok | {error, term()}.
start_phase(start_trails_http, _StartType, []) ->
    {ok, Port} = application:get_env(catalog, http_port),
    {ok, ListenerCount} = application:get_env(catalog, http_listener_count),

    Handlers = [ catalog_handler
        , cowboy_swagger_handler
    ],

    %% Get the trails for each handler
    Trails = [ { "/"
        , cowboy_static
        , {file, filename:join([code:priv_dir(catalog), "index.html"])}}
        , { "/assets/[...]"
            , cowboy_static
            , {dir, filename:join([code:priv_dir(catalog), "assets"])}}
        | trails:trails(Handlers)
    ],

    %% Store them so Cowboy is able to get them
    trails:store(Trails),
    %% Set server routes
    Dispatch = trails:single_host_compile(Trails),
    RanchOptions = [{port, Port}],
    CowboyOptions =
        [
            {env,
                [
                    {dispatch, Dispatch}
                ]},
            {compress, true},
            {timeout, 12000}
        ],
    %% Start Cowboy HTTP server
    case cowboy:start_http( catalog
        , ListenerCount
        , RanchOptions
        , CowboyOptions) of
        {ok, _} -> ok;
        {error, {already_started, _}} -> ok
    end.
