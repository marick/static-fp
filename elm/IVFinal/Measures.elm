module IVFinal.Measures exposing
  ( DropsPerSecond
  , TimePerDrop
  , Minutes
  , Hours

  , dripRate
  , minutes
  , hours
  , toMinutes
    
  , rateToDuration
  , reduceBy
  )

import Tagged exposing (Tagged(..), untag, retag)
import IVFinal.Util.AppTagged exposing (UnusableConstructor)
import Time

dripRate : Float -> DropsPerSecond
dripRate = Tagged

rateToDuration : DropsPerSecond -> TimePerDrop
rateToDuration dps =
  let
    calculation rate =
      (1 / rate ) * Time.second
  in
    Tagged.map calculation dps |> retag

changeBy : (number -> number -> number)
        -> Tagged a number -> Tagged a number
        -> Tagged a number
changeBy f decrement value =
  Tagged.map2 f value decrement

reduceBy : Tagged a number -> Tagged a number -> Tagged a number
reduceBy = changeBy (-)


minutes : Int -> Minutes
minutes = Tagged

hours : Int -> Hours
hours = Tagged

toMinutes : Hours -> Minutes -> Minutes
toMinutes (Tagged hourPart) (Tagged minutePart) =
  minutes <| 60 * hourPart + minutePart
  

--- Support for tagging

type alias DropsPerSecond = Tagged DropsPerSecondTag Float
type DropsPerSecondTag = DropsPerSecondTag UnusableConstructor

type alias TimePerDrop = Tagged TimePerDropTag Float
type TimePerDropTag = TimePerDropTag UnusableConstructor

type alias Minutes = Tagged MinutesTag Int
type MinutesTag = MinutesTag UnusableConstructor

type alias Hours = Tagged HoursTag Int
type HoursTag = HoursTag UnusableConstructor

