import Html
import Html.Attributes

names = [ "Pearl", "Steven", "Garnet", "Amethyst" ]

main =
  let
    sorted =
      List.sort names
    texts =
      List.map Html.text sorted
    textToItem text =
      Html.li
        [ Html.Attributes.style [ ("font-style", "italic") ] ]
        [ text ]
    items =
      List.map textToItem texts
  in
    Html.div
      [ Html.Attributes.style
        [ ("position", "absolute")
        , ("width", "10em")
        , ("height", "10em")
        , ("top", "50%")
        , ("left", "50%")
        , ("transform", "translateX(-50%) translateY(-50%)")
        , ("overflow", "hidden")
        ]
      ]
      [ Html.ul [] items ]
