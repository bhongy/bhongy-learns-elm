module Todo where

{-| TodoMVC implemented in Elm, using plain HTML and CSS for rendering.

This application is broken up into four distinct parts:

  1. Model  - a full definition of the application's state
  2. Update - a way to step the application state forward
  3. View   - a way to visualize our application state with HTML
  4. Inputs - the signals necessary to manage events

This clean division of concerns is a core part of Elm. You can read more about
this in the Pong tutorial: http://elm-lang.org/blog/making-pong

This program is not particularly large, so definitely see the following
for notes on structuring more complex GUIs with Elm:
https://github.com/evancz/elm-architecture-tutorial/

@bhongy ---
  Model  is the state of our application (how it looks like at a certain point in time)
  Action is (data, events) what needs to happen
  Update is "how" would we change Model when we see a particular Action
  View   is just a function to represent the Model (always the same given the same state)

-}

import Signal exposing (Address, Signal)

import String

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy2, lazy3)
import Json.Decode




-- MODEL

type alias ID =
  Int


type alias Visibility =
  String


type alias Task =
  { id          : ID
  , description : String
  , editing     : Bool
  , completed   : Bool
  }


type alias Model =
  { uid        : Int
  , input      : String
  , tasks      : List Task
  , visibility : Visibility
  }


newTask : Int -> String -> Task
--newTask id desc = Task id desc False False
newTask id desc =
  { id          = id
  , description = desc
  , editing     = False
  , completed   = False
  }


emptyModel : Model
--emptyModel = 0 "" [] "All"
emptyModel =
  { uid        = 0
  , input      = ""
  , tasks      = []
  , visibility = "All"
  }




-- UPDATE

-- A description of the kinds of actions that can be performed on the model of
-- our application. See the following for more info on this pattern and
-- some alternatives: https://github.com/evancz/elm-architecture-tutorial/
type Action
  = NoOp
  | UpdateInput String
  | EditTask ID Bool
  | UpdateTask ID String
  | Add
  | Delete ID
  | DeleteComplete
  | Check ID Bool
  | CheckAll Bool
  | ChangeVisibility Visibility


-- How we update our Model on a given Action?
update : Action -> Model -> Model
update action model =
  case action of

    NoOp ->
      model

    UpdateInput inputValue ->
      { model | input = inputValue }

    -- ? how to abstract/DRY this and UpdateTask ?
    -- ? is there a pattern to pass the field to be edited ?
    -- ? or how can pass `updateTask` as callback or something ?
    EditTask id isEditing ->
      let
        updateTask task =
          if task.id == id then
            { task | editing = isEditing }
          else
            task
      in
        { model | tasks = List.map updateTask model.tasks }

    UpdateTask id description ->
      let
        updateTask task =
          if task.id == id then
            { task | description = description }
          else
            task
      in
        { model | tasks = List.map updateTask model.tasks }

    Add ->
      let
        taskToAdd = newTask model.uid model.input
      in
        if not ( String.isEmpty model.input ) then
          { model
              | uid        = model.uid + 1
              , input      = ""
              , tasks      = model.tasks ++ [ taskToAdd ]
          }
        else
          model

    Delete id ->
      { model
          | tasks = List.filter (\ task -> task.id /= id ) model.tasks
      }

    -- WOW! cool implementation with `<<`
    DeleteComplete ->
      { model
          | tasks = List.filter ( not << .completed ) model.tasks
      }

    Check id isCompleted ->
      let
        updateTask task =
          if task.id == id then
            { task | completed = isCompleted }
          else
            task
      in
        { model | tasks = List.map updateTask model.tasks }

    CheckAll isCompleted ->
      let
        updateTask task = { task | completed = isCompleted }
      in
        { model | tasks = List.map updateTask model.tasks }        

    ChangeVisibility visibility ->
      { model | visibility = visibility }




-- VIEW

is13 : Int -> Result String ()
is13 code =
  if code == 13 then
    Ok ()
  else
    Err "not the right key code"


onEnter : Address Action -> Action -> Attribute
onEnter address action =
  on "keydown"
    -- need to really learn to create custom decoder
    -- `keyCode` grabbing Javascript `event.keyCode`
    --   from the triggered event
    (Json.Decode.customDecoder keyCode is13)
    (\ _ -> Signal.message address action)


onInput : Address Action -> (String -> Action) -> Attribute
onInput address action =
  on "input"
    targetValue
    --(Signal.message address << action)
    (\ value -> Signal.message address (action value) )


taskEntry : Address Action -> String -> Html
taskEntry address task =
  header
    [ id "header" ]
    [ h1 [] [ text "todos" ]
    , input
        [ id "new-todo"
        , placeholder "What needs to be done?"
        , autofocus True
        , value task
        , name "newTodo"
        , onInput address UpdateInput
        , onEnter address Add
        ]
        []
    ]


todoItem : Address Action -> Task -> Html
todoItem address todo =
  li
    [ classList
        [ ("completed", todo.completed)
        , ("editing", todo.editing)
        ]
    ]
    [ div
        [ class "view" ]
        [ input
            [ class "toggle"
            , type' "checkbox"
            , checked todo.completed
            , onClick address
                <| Check todo.id
                <| not todo.completed
            ]
            []
        , label
            [ onDoubleClick address <| EditTask todo.id True ]
            [ text todo.description ]
        , button
            [ class "destroy"
            , onClick address <| Delete todo.id
            ]
            []
        ]
    , input
        [ class "edit"
        , value todo.description
        , name "title"
        , id ("todo-" ++ toString todo.id)
        , onInput address <| UpdateTask todo.id
        , onBlur address <| EditTask todo.id False
        , onEnter address <| EditTask todo.id False
        ]
        []
    ]


taskList : Address Action -> Visibility -> List Task -> Html
taskList address visibility tasks =
  let

    isVisible todo =
      case visibility of
        "Completed" -> todo.completed
        "Active"    -> not todo.completed
        _           -> True

    allCompleted =
      List.all .completed tasks

    cssVisibility =
      if List.isEmpty tasks then
        "hidden"
      else
        "visible"

  in
    section
      [ id "main"
      -- hide the list if the list is empty
      , style [ ("visibility", cssVisibility) ]
      ]
      [ input
          [ id "toggle-all"
          , type' "checkbox"
          , name "toggle"
          , checked allCompleted
          , onClick address
              <| CheckAll
              -- toggle the opposite of `allCompleted`
              -- make either all completed or all incompleted
              -- (no mix)
              <| not allCompleted
          ]
          []
      , label
          [ for "toggle-all" ]
          [ text "Mark all as complete" ]
      , ul
          [ id "todo-list" ]
          -- show based on `visibility` value
          ( List.filter isVisible tasks
              |> List.map (todoItem address)
          )
      ]


visibilitySwap : Address Action -> String -> Visibility -> Visibility -> Html
visibilitySwap address uri target actual =
  li
    [ onClick address <| ChangeVisibility target ]
    [ a
        [ href uri
        , classList [( "selected", target == actual )]
        ]
        [ text target ]
    ]


-- links to toggle visibility of the list
visibilityControls : Address Action -> Visibility -> List Task -> Html
visibilityControls address visibility tasks =
  let

    numTasksCompleted =
      List.filter .completed tasks
        |> List.length

    numTasksLeft =
      List.length tasks - numTasksCompleted

    unitString =
      if numTasksLeft == 1 then
        " item"
      else
        " items"

  in
    footer
      [ id "footer"
      -- hide the links if the list is empty
      -- ? a way to bailout the function early if tasks is empty ?
      , hidden (List.isEmpty tasks)
      ]
      [ span
          [ id "todo-count" ]
          [ strong [] [ toString numTasksLeft |> text ]
          , text (unitString ++ " left")
          ]
      , ul
          [ id "filters" ]
          [ visibilitySwap address "#/" "All" visibility
          , text " "
          , visibilitySwap address "#/active" "Active" visibility
          , text " "
          , visibilitySwap address "#/completed" "Completed" visibility
          ]
      , button
          [ id "clear-completed"
          , class "clear-completed"
          , hidden (numTasksCompleted == 0)
          , onClick address DeleteComplete
          ]
          [ text ( "Clear completed (" ++ toString numTasksCompleted ++ ")" )]
      ]


infoFooter : Html
infoFooter =
  let
    linkInfo { description, linkUrl, linkText } =
      p
        []
        [ text (description ++ " ")
        , a [ href linkUrl ] [ text linkText ]
        ]
  in
    footer
      [ id "info" ]
      [ p [] [ text "Double-click to edit a todo" ]

      , linkInfo
          { description = "Originally written by"
          , linkUrl = "https://github.com/evancz"
          , linkText = "Evan Czaplicki"
          }

      , linkInfo
          { description = "Learned and refactored by "
          , linkUrl = "https://github.com/bhongy"
          , linkText = "Thanik Bhongbhibhat"
          }

      , linkInfo
          { description = "Part of"
          , linkUrl = "http://todomvc.com"
          , linkText = "TodoMVC"
          }

      ]


view : Address Action -> Model -> Html
view address model =
  div
    [ class "todomvc-wrapper"
    , style
        [ ("visibility", "hidden") ]
    ]
    [ section
        [ id "todoapp" ]
        [ lazy2 taskEntry address model.input
        , lazy3 taskList address model.visibility model.tasks
        , lazy3 visibilityControls address model.visibility model.tasks
        ]
    , infoFooter
    ]




-- PORTS

port getStorage : Maybe Model


port setStorage : Signal Model
port setStorage =
  modelChanges


port focus : Signal String
port focus =
  let
    initialEditTaskSignal =
      EditTask 0 True

    needsFocus action =
      case action of
        EditTask id bool -> bool
        _ -> False

    toSelector action =
      case action of
        EditTask id _ -> "#todo-" ++ toString id
        _ -> ""

  in
    actions.signal
      -- filter for EditTask signals only
      |> Signal.filter needsFocus initialEditTaskSignal
      -- transform action signal to signal of string value (selector)
      |> Signal.map toSelector

