module IVFinal.View.InputFields exposing (..)

import Html
import Html.Attributes as HA
import IVFinal.Measures as Measure
import IVFinal.Util.ValidatedString as ValidatedString 
  exposing (checked, ValidatedString)
import Maybe.Extra as Maybe
import Random

type alias DripRate = ValidatedString Measure.DropsPerSecond
type alias Hours = ValidatedString Measure.Hours
type alias Minutes = ValidatedString Measure.Minutes

border : ValidatedString a -> Html.Attribute msg
border validated =
  case validated.value of
    Nothing ->
      HA.style [("border", "1px solid red")]
    Just _ -> 
      HA.style [("border", "1px solid grey")]



dripRate : String -> DripRate
dripRate =
  createVia
    String.toFloat
    (\ float -> float > 0)
    Measure.dripRate

-- Note: there's a bug in 0.18 Elm such that `String.toInt "-"`
-- produces a `NaN`. https://github.com/elm-lang/core/issues/831
-- Because NaN is larger than any value, the pure zero-check below
-- succeed for the input "-". NaN is smaller than any value, so we ask
-- if the parse result is less than maxint which, alas, is only
-- available from Random.
      
hours : String -> Hours
hours = 
  createVia
    String.toInt
    (\ i -> i >= 0 && i <= Random.maxInt)
    Measure.hours
      
minutes : String -> Minutes
minutes =
  createVia
    String.toInt
    (\ i -> i >= 0 && i < 60)
    Measure.minutes


createVia : (String -> Result err base)  -- string parser
         -> (base -> Bool)               -- parses, but is it valid?
         -> (base -> measure)            -- convert to measure
         -> String                       -- allow partial
         -> ValidatedString measure
createVia parser validator converter string =
  parser string
    |> Result.toMaybe
    |> Maybe.filter validator
    |> Maybe.map converter
    |> checked string
  

      
      
    -- (\ int ->
    --    if int < 0 then
    --      Nothing
    --    else if int > 59 then 
    --      Nothing
    --    else
    --      Just <| Measure.minutes int)
       
  -- let
  --   toValidMinute int = 
  --     if int < 0 then
  --       Nothing
  --     else if int > 59 then 
  --       Nothing
  --     else
  --       Just <| Measure.minutes int
  -- in
  --   String.toInt string
  --     |> Result.toMaybe
  --     |> Maybe.andThen toValidMinute
  --     |> checked string
       
-- dripRate : String -> DripRate
-- dripRate string =
--   validate string String.toFloat
--     (\ float ->
--        if float <= 0 then 
--          Nothing
--        else 
--          Just <| Measure.dripRate float)
