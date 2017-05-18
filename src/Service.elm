module Service exposing (getProducts)

import Http
import Decoders exposing (products)
import Messages exposing (Msg(ReceiveProducts))
import Urls

getProducts : Cmd Msg
getProducts =
    Http.get Urls.products products
        |> Http.send ReceiveProducts
