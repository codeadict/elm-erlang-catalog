module Model exposing (..)

type alias Model =
    { products : List Product}


init : Model
init =
    Model []


type alias Product =
    { id : Int
    , name : String
    , price : Float
    }
