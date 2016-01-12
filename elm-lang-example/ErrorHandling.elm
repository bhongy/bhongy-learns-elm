import Graphics.Element exposing (show)
import Http
import Json.Decode
import Task exposing (Task, andThen, onError, succeed, toResult)
import TaskTutorial exposing (print)


fetchUrl : String
fetchUrl =
  "http://example.com/hat-list.json"


get : Task Http.Error (List String)
get =
  Http.get ( Json.Decode.list Json.Decode.string ) fetchUrl


-- handle error using `Task.onError`
safeGet1 : Task x (List String)
safeGet1 =
  get `onError` (\ err -> succeed [] )


-- handle error using `Task.toResult`
safeGet2 : Task x (Result Http.Error (List String))
safeGet2 =
  Task.toResult get


port runner : Task x ()
port runner =
  --safeGet1 `andThen` print
  safeGet2 `andThen` print


main =
  show "Open the Developer Console of your browser."
