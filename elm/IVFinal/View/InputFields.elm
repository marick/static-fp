module IVFinal.View.InputFields exposing (..)

import Html
import Html.Attributes as HA
import IVFinal.Measures as Measure
import IVFinal.Util.ValidatedString as ValidatedString 
  exposing (checked, ValidatedString)

type alias DripRate = ValidatedString Measure.DropsPerSecond

-- re-expose so clients don't have to also import ValidatedString
whenValid : ValidatedString a -> result -> (a -> result) -> result
whenValid = ValidatedString.whenValid


border : ValidatedString a -> Html.Attribute msg
border validated =
  case validated.value of
    Nothing ->
      HA.style [("border", "1px solid red")]
    Just _ -> 
      HA.style [("border", "1px solid grey")]

dripRate : String -> DripRate
dripRate string =
  case String.toFloat string of
    Err _ ->
      checked string Nothing
    Ok 0.0 ->
      checked string Nothing
    Ok float ->
      checked string (Just <| Measure.dripRate float)


        
