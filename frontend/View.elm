module View exposing (view)

import Html exposing (Html, main_, h1, table, caption, thead, tr, th, tbody, td, text, span, img)
import Html.Attributes exposing (class, align, width)
import Model exposing (..)
import Numeral exposing (format)
import Messages exposing (Msg(..))

productView : Product -> Html Msg
productView product =
  tr []
    [ td [] [ text product.name ]
      , td [align "right"] [ text (formatPrice product.price) ]
      ]


formatPrice : Float -> String

formatPrice price =
  format "$0,0.00" price


view : Model -> Html Msg
view model =
    main_ [ class "elm-products-page" ]
        [ h1 [] [ text "Products" ]
        , table []
            [thead []
              [ tr []
                [ th [align "left", width 100] [ text "Name" ]
                , th [align "right", width 100] [ text "Price" ]
                ]
              ]
            , tbody [] (List.map (productView) model.products)
          ]
        ]
