-module(catalog_handler).
-author("codeadict").

-include_lib("mixer/include/mixer.hrl").
-mixin([
  {rest_mixin,
    [
      init/3,
      rest_init/2,
      content_types_accepted/2,
      content_types_provided/2,
      resource_exists/2
    ]}
]).

%% API
-export([
         allowed_methods/2,
         handle_get/2
        ]).


%% trails
-behaviour(trails_handler).
-export([trails/0]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Trails Definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-spec trails() -> trails:trails().
trails() ->
    Metadata =
        #{ get =>
               #{ description => "Returns the list of Products"
                , produces    => ["application/json"]
                }
         },
    [trails:trail("/products", catalog_handler, [], Metadata)].


%% cowboy
allowed_methods(Req, State) ->
    {[<<"GET">>], Req, State}.

to_json(Req, State) ->
    Reply = [ #{id => 1, name => <<"iPhone 7 Plus">>, price => 675.00}
            , #{id => 2, name => <<"NES case for Raspberry Pi 3">>, price => 19.85}
            , #{id => 3, name => <<"Echo Dot (2nd Generation) - Black">>, price => 49.99}
            , #{id => 4, name => <<"Pebble Time Steel Smartwatch">>, price => 102.95}
            , #{id => 5, name => <<"Nest Cam Indoor security camera">>, price => 163.80}
            , #{id => 6, name => <<"Bose SoundLink Bluetooth Speaker III">>, price => 258.99}
            , #{id => 7, name => <<"Hubsan X4 4 Channel 2.4GHz RC Quad Copter">>, price => 33.23}
            , #{id => 8, name => <<"USB Classic Super Nintendo Controller">>, price => 19.95}
            ],
    JSON = jsx:encode(Reply),
    {JSON, Req, State}.

handle_get(Req, State) ->
    lager:info("Get GET request on products resource"),
    to_json(Req, State).


