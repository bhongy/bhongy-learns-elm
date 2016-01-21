module CounterList
  ( Model
  , init
  , view
  )
  where

import Counter
import Html exposing (..)
import Html.Attributes exposing (..)




-- MODEL

type alias ID =
  Int


type alias Model =
  List ( ID, Signal Counter.Model )


init : Model
init =
  [ ( 0, Counter.init 0 )
  , ( 1, Counter.init 10 )
  ]




-- VIEW(S)

eachView : ( ID, Signal Counter.Model ) -> Html
eachView ( id, counterModel ) =
  li
    []
    [ Counter.view counterModel
    , button
        [ onClick Remove id ] 
        [ text "x" ]
    , p
        [ style [("color", "pink")] ]
        [ text ( "counterID: " ++ (toString id) ) ]
    ]


view : Model -> Html
view model =
  div
    []
    [ button
        []
        [ text "add" ]
    , ul
        []
        ( List.map eachView model )
    ]
