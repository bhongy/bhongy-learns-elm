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
-}

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
