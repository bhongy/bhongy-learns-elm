-- Elm Architecture Boiler Plate --

-- Model

type alias Model = { ... }


-- Update

type Action = Reset | ...

update : Action -> Model -> Model
update action model =
  case action of
    Reset -> ...
    ...


-- View

view : Model -> Html
view =
  ...
