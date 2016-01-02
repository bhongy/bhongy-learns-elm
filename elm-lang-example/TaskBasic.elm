import Graphics.Element exposing (show)
import Task exposing (Task)
import TaskTutorial as Tutorial
import Time exposing (Time, second)


-- A signal that updates to the current time every second
clock : Signal Time
clock =
  Time.every second


-- Turns the clock into a signal of tasks
printTasks : Signal ( Task err () )
printTasks =
  Signal.map Tutorial.print clock


-- Actually perform all those tasks
port runner : Signal ( Task err () )
port runner =
  printTasks


main =
  show "Open your browser's Developer Console."
