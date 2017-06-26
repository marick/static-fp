module IVFinal.Measures exposing
  ( DropsPerSecond
  , Liters
  , LitersPerMinute
  , Minutes
  , Hours
  , Percent

  , dripRate
  , flowRate
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

--
dripRate : Float -> DropsPerSecond
dripRate = Tagged

--
flowRate : DropsPerSecond -> LitersPerMinute
flowRate (Tagged dropsPerSecond) =
  let
    dropsPerMil = 15.0
    milsPerSecond = dropsPerSecond / dropsPerMil
    milsPerHour = milsPerSecond * 60.0
  in
    Tagged <| milsPerHour / 1000.0 

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

type alias DropsPerSecond = Tagged DropsPerSecondTag Float
type DropsPerSecondTag = DropsPerSecondTag UnusableConstructor

type alias LitersPerMinute = Tagged LitersPerMinuteTag Float
type LitersPerMinuteTag = LitersPerMinuteTag UnusableConstructor

type alias Minutes = Tagged MinutesTag Int
type MinutesTag = MinutesTag UnusableConstructor

type alias Hours = Tagged HoursTag Int
type HoursTag = HoursTag UnusableConstructor

type alias Liters = Tagged LitersTag Float
type LitersTag = LitersTag UnusableConstructor

type alias Percent = Tagged PercentTag Float
type PercentTag = PercentTag UnusableConstructor

