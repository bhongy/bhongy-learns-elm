import Graphics.Element exposing (show)
import Task exposing (Task, andThen)
import TaskTutorial exposing (getCurrentTime, print)


printTime : Task x ()
printTime =
  --getCurrentTime `andThen` print

  -- prefer more explicit version
  getCurrentTime `andThen` (\ time -> print time )


port runner : Task x ()
port runner =
  printTime


main =
  show "Open the Developer Console of your browser."
