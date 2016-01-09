module Main where

import Counter
import Html exposing (Html)


init : Counter.Model
init =
  Counter.init 0


-- ? better pattern ? importing Html module just to annotate `main` ?
--   thinking about Counter.View is an alias for Html ? not sure that's better
main : Html
main =
  Counter.view init
