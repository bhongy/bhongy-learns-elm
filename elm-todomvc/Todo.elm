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

import String

--import Html exposing (..)
--import Html.Attributes
--import Html.Events
--import Html.Lazy


-- MODEL

type alias ID = Int

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
  , visibility : String
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
  | ChangeVisibility String


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
