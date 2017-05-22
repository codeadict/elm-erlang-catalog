module Decoders exposing (..)

import Model exposing (Product)
import Json.Decode exposing (..)

product : Decoder Product
product =
    map3 Product
        (field "id" int)
        (field "name" string)
        (field "price" float)


products : Decoder (List Product)
products =
    list product
