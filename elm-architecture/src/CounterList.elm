module CounterList
  ( init
  , update
  , view
  ) where


import Counter
import Html exposing (Html, div, button, text)
import Html.Events exposing (onClick)




-- MODEL

type alias ID =
  Int


type alias Model =
  { counters : List ( ID, Counter.Model )
  , nextID : ID
  }


init : Model
init =
  -- Model [] 0    -- short-hand using type constructor
  { counters = []
  , nextID = 0
  }




-- UPDATE

type Action
  = Insert
  | Remove ID                 -- remove, which one
  | Modify ID Counter.Action  -- modify, which one, how


update : Action -> Model -> Model
update action model =
  case action of

    Insert ->
      let newCounter =
        ( model.nextID, Counter.init 0 )
      in
        -- "amend" only to the fields that needed
        -- safer pattern if `model` changes in the future
        { model
          | counters = model.counters ++ [ newCounter ]
          , nextID = model.nextID + 1
        }

    Remove id ->
      let toKeep ( counterID, _ ) = counterID /= id      
      in
        { model
          | counters = List.filter toKeep model.counters
        }

    -- makes sense if read "counterAction" -> "how"
    Modify id counterAction ->
      let
        updateCounter ( eachID, eachModel ) =
          if eachID == id then
            ( eachID, Counter.update counterAction eachModel )
          else
            ( eachID, eachModel )
      in
        { model
          | counters = List.map updateCounter model.counters
        }




---- VIEW

--viewCounter : Signal.Address Action -> (ID, Counter.Model) -> Html
--viewCounter address (id, model) =
--  let
--    modifyAddress = Modify id |> Signal.forwardTo address
--    removeAddress = Remove id |> always |> Signal.forwardTo address

--    -- use type contrustor function
--    context = Counter.Context modifyAddress removeAddress
--  in
--    Counter.removableView context model


--view : Signal.Address Action -> Model -> Html
--view address model =
--  let
--    counters = List.map (viewCounter address) model.counters
--    insert = button [ onClick address Insert ] [ text "Add" ]
--  in
--    div [] ( insert :: counters )
