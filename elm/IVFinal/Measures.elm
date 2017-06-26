module IVFinal.Measures exposing
  ( DropsPerSecond
  , Liters
  , Minutes
  , Hours
  , Percent

  , dripRate
  , liters
  , minutes
  , hours
  , percent
  , percentDecrease
  , percentRemaining
    
  , reduceBy
  )

import Tagged exposing (Tagged(..), untag, retag)
import IVFinal.Util.AppTagged exposing (UnusableConstructor)

-- Types
type alias DropsPerSecond = Tagged DropsPerSecondTag Float
type alias Minutes = Tagged MinutesTag Int
type alias Hours = Tagged HoursTag Int
type alias Liters = Tagged LitersTag Float
type alias Percent = Tagged PercentTag Float



--
dripRate : Float -> DropsPerSecond
dripRate = Tagged

--
percent : Float -> Percent
percent = Tagged

percentDecrease : Float -> Float -> Percent
percentDecrease start amountRemoved =
  (start - amountRemoved) / start |> percent

percentRemaining : Float -> Float -> Percent
percentRemaining start amountRemoved =
  let
    (Tagged decrease) = percentDecrease start amountRemoved
  in
    1.0 - decrease |> percent

--
minutes : Int -> Minutes
minutes = Tagged

hours : Int -> Hours
hours = Tagged

--
liters : Float -> Liters
liters = Tagged

-- Generic
    
changeBy : (number -> number -> number)
        -> Tagged a number -> Tagged a number
        -> Tagged a number
changeBy f decrement value =
  Tagged.map2 f value decrement

reduceBy : Tagged a number -> Tagged a number -> Tagged a number
reduceBy = changeBy (-)


--- Support for tagging

type DropsPerSecondTag = DropsPerSecondTag UnusableConstructor
type MinutesTag = MinutesTag UnusableConstructor
type HoursTag = HoursTag UnusableConstructor
type LitersTag = LitersTag UnusableConstructor
type PercentTag = PercentTag UnusableConstructor

