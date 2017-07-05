module IVFinal.App.Html exposing
  ( soloButton
  , textInput
  )

{-| Some "reusable components"
-}

import IVFinal.Generic.ValidatedString exposing (ValidatedString)
import Html exposing (..)
import Html.Attributes exposing (..)

{-| A button that's expected to stand alone in its own `p`.

    H.soloButton "Restart"
      [ Event.onClick ResetSimulation ]
-}
soloButton : String -> List (Attribute msg) -> Html msg
soloButton label attributes =
  Html.p []
    [ Html.button attributes 
        [strong [] [text label]]
    ]


{-| A small text input field that displays a `ValidatedString`

    H.textInput desiredHours [ Event.onInput ChangeHours ]
-}
textInput : ValidatedString a  -> List (Html.Attribute msg) -> Html msg
textInput validated attributes = 
  input ([ type_ "text"
         , value validated.literal
         , size 6
         , visualValidation validated
         ] ++ attributes)
  []


-- Util

visualValidation : ValidatedString a -> Html.Attribute msg
visualValidation validated =
  case validated.value of
    Nothing ->
      style [ ("border", "1px solid black")
            , ("background-color", "pink")
            ]
    Just _ -> 
      style [("border", "1px solid grey")]
