import Html

multiply : number -> number -> number
multiply a b =
  a * b

square : number -> number
square a = multiply a a

productOfSquares : number -> number -> number
productOfSquares a b = multiply (square a) (square b)

incrementAll : List number -> List number
incrementAll list = List.map (\ n -> n + 1) list

incrementAll2 : List number -> List number
incrementAll2 = List.map (\ n -> n + 1)

main : Html.Html
main =
  let
    print n = Html.text <| toString n
    br = Html.br [] []
  in
    Html.p []
    [ print <| multiply 3 5
    , br
    , print <| square 4
    , br
    , print <| productOfSquares 2 3
    , br
    , print <| incrementAll [1, 2, 3]
    , br
    , print <| incrementAll2 [1, 2, 3]
    ]