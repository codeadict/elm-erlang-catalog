module Update exposing (update)

import Model exposing (Model)
import Messages exposing (Msg(..))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      ReceiveProducts (Ok data) ->
        ( { model | products = data }, Cmd.none )

      ReceiveProducts (Err _) ->
        ( model, Cmd.none )
