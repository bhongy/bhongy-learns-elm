module Counter
  ( Model
  , init
  , view
  )
  where

import Html exposing (..)
import Html.Attributes exposing (style)




-- MODEL

type alias Model =
  Int


-- ? How to use (Maybe Int) to default to 0 if passing nothing ?
init : Int -> Model
init initialCount =
  initialCount




-- VIEW(S)

-- { Attribute }
-- module Html contains `type alias Attribute = Property`
-- not from Html.Attributes

buttonStyle : Attribute
buttonStyle =
  style
    [ ("display", "inline-block")
    , ("vertical-align", "middle")
    ]


countStyle : Attribute
countStyle =
  style
    [ ("display", "inline-block")
    , ("font-size", "24px")
    , ("font-family", "monospace")
    , ("padding", "0 1em") -- adapt to font-size
    , ("text-align", "center")
    , ("vertical-align", "middle")
    ]


view : Model -> Html
view model =
  p
    []
    [ button
        [ buttonStyle ]
        [ text "-" ]
    , span
        [ countStyle ]
        [ text <| toString model ]
    , button
        [ buttonStyle ]
        [ text "+" ]
    ]
