import Http
import Markdown
import Html exposing (Html)
import Task exposing (Task, andThen)


readmeUrl : String
readmeUrl =
  "https://raw.githubusercontent.com/elm-lang/core/master/README.md"


readmeMailbox : Signal.Mailbox String
readmeMailbox =
  Signal.mailbox ""


sendToMailbox : String -> Task x ()
sendToMailbox markdown =
  Signal.send readmeMailbox.address markdown


port fetchReadme : Task Http.Error ()
port fetchReadme =
  Http.getString readmeUrl `andThen` sendToMailbox


main : Signal Html
main =
  Signal.map Markdown.toHtml readmeMailbox.signal
