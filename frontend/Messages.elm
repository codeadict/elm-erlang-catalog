module Messages exposing (Msg(..))

import Http
import Model exposing (Product)


type Msg
    = ReceiveProducts (Result Http.Error (List Product))
