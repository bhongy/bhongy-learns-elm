module CounterList
  ( init
  , update
  , view
  )
  where

import Counter
import Html exposing (Html, div, button, text)
import Html.Events exposing (onClick)


-- MODEL

type alias ID = Int

type alias Model =
  { counters : List ( ID, Counter.Model )
  , nextID : ID
  }


init : Model
init =
  { counters = []
  , nextID = 0
  }


-- UPDATE

type Action
  = Insert
  | Remove
  | Modify ID Counter.Action


update : Action -> Model -> Model
update action model =
  case action of

    Insert ->
      let newCounter = ( model.nextID, Counter.init 0 )
      in
        { model
          | counters = model.counters ++ [ newCounter ]
          , nextID = model.nextID + 1
        }

    Remove ->
      { model |
          counters = List.drop 1 model.counters
      }

    Modify id counterAction ->
      let updateCounter ( counterID, counterModel ) =
        if counterID == id
        then ( counterID, Counter.update counterAction counterModel )
        else ( counterID, counterModel )
      in
        { model | counters = List.map updateCounter model.counters }


-- VIEW

viewCounter : Signal.Address Action -> (ID, Counter.Model) -> Html
viewCounter address (id, model) =
  let modifyAddress = Signal.forwardTo address (Modify id)
  in
    Counter.view modifyAddress model


view : Signal.Address Action -> Model -> Html
view address model =
  let
    counters = List.map (viewCounter address) model.counters
    remove = button [ onClick address Remove ] [ text "Remove" ]
    insert = button [ onClick address Insert ] [ text "Add" ]
  in
    div []
      ( [ remove, insert ] ++ counters )
