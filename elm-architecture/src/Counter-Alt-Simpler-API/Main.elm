module Main where

import Counter
import Html exposing (Html)


-- ? better pattern ? importing Html module just to annotate `main` ?
--   thinking about Counter.View is an alias for Html ? not sure that's better
main : Signal Html
main =
  Counter.init 0
