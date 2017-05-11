module Architecture1.Style exposing
  ( iteratedText
  )
import Html
import Html.Attributes exposing (..)

iteratedText : Int -> Html.Attribute msg
iteratedText iteration =
  style [ ("color", colorWheelString iteration)
        , ("font-size", fontSizeString iteration)
        ]
      
colorWheelString : Int -> String
colorWheelString iteration =
  let
    color = rem iteration 360 |> toString
  in
    "hsl(" ++ color ++ ", 100%, 50%)"

fontSizeString : Int -> String
fontSizeString iteration =
  let
    size = 1 + rem iteration 12
  in
    toString size ++ "em"
    
