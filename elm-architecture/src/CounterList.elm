module CounterList
  ( init
  , update
  , view
  ) where


import Counter
import Html exposing (Html, Attribute, div, ul, li, button, text)
import Html.Attributes exposing (style)
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




-- VIEW

viewCounter : Signal.Address Action -> (ID, Counter.Model) -> Html
viewCounter address (id, model) =

  -- @bhongy, I don't fully understand .forwardTo conceptually
  --   need to try more examples until it "clicks"

  -- list will receive "Modify" action with "id"
  -- and forwarding the "counterAction" to "Counter.update"
  -- use this pattern when you have nested components that need
  --   to pass the Action down

  let modifyAddress = Signal.forwardTo address <| Modify id
  in
    li []
      [ Counter.view modifyAddress model
      , button [ onClick address <| Remove id ] [ text "x" ]
      ]


-- "Insert" and "Remove" are properties (methods) of the list
-- "Modify" is the property of each individual Counter
--   the list just passes the information to the correct Counter

view : Signal.Address Action -> Model -> Html
view address model =
  -- create variable here so it is clear what this is
  let counters = List.map (viewCounter address) model.counters
  in
    div []
      [ button [ onClick address Insert ] [ text "Add" ]
      , ul [ listStyle ] counters
      ]


listStyle : Attribute
listStyle =
  style
    [ ("list-style", "none")
    , ("padding-left", "0")
    ]
