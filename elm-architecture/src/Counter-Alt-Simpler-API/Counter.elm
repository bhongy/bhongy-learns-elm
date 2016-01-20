module Counter (init) where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events as Events




-- MODEL

type alias Model =
  Int


-- ? How to use (Maybe Int) to default to 0 if passing nothing ?
init : Int -> Signal Html
init initialCount =
  let
    modelSignal = Signal.foldp update initialCount actionDispatcher.signal
  in 
    Signal.map view modelSignal




-- UPDATE

type Action
  = NoOp
  | Increment
  | Decrement


update : Action -> Model -> Model
update action model =
  case action of

    NoOp ->
      model

    Increment ->
      model + 1

    Decrement ->
      model - 1




-- ACTION DISPATCHER (MAILBOX)

actionDispatcher : Signal.Mailbox Action
actionDispatcher =
  Signal.mailbox NoOp


onClick action =
  Events.onClick actionDispatcher.address action




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
        [ buttonStyle 
        , onClick Decrement ]
        [ text "-" ]
    , span
        [ countStyle ]
        [ text <| toString model ]
    , button
        [ buttonStyle
        , onClick Increment
        ] 
        [ text "+" ]
    ]
