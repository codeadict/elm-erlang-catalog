module Main exposing(..)

import Html exposing (program)
import Model exposing (Model)
import Update exposing (update)
import View exposing (view)
import Messages exposing (Msg(..))
import Service exposing (getProducts)


init : (Model, Cmd Msg)
init =
    ( Model.init
    , getProducts
    )

subscriptions : Model -> Sub Msg
subscriptions products =
        Sub.none

main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
