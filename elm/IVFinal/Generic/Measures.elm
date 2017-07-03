module IVFinal.Generic.Measures exposing
  ( DropsPerSecond
  , LitersPerMinute
  , Liters
  , Seconds
  , Minutes
  , Hours
  , Percent

  , dripRate
  , litersPerMinute
  , liters
  , seconds
  , toSeconds
  , minutes
  , hours
  , percent
  , proportion
    
  , reduceBy
  , isStrictlyNegative
  )

import Tagged exposing (Tagged(Tagged))
import IVFinal.Generic.Tagged exposing (UnusableConstructor)

-- Types
type alias DropsPerSecond = Tagged DropsPerSecondTag Float
type alias Seconds = Tagged SecondsTag Float
type alias Minutes = Tagged MinutesTag Int
type alias Hours = Tagged HoursTag Int
type alias Liters = Tagged LitersTag Float
type alias Percent = Tagged PercentTag Float
type alias LitersPerMinute = Tagged LitersPerMinuteTag Float

--
dripRate : Float -> DropsPerSecond
dripRate = Tagged

litersPerMinute : Float -> LitersPerMinute
litersPerMinute = Tagged

--
percent : Float -> Percent
percent = Tagged

proportion : Tagged a Float -> Tagged a Float -> Percent
proportion (Tagged first) (Tagged second) =
  percent (first / second)

--
seconds : Float -> Seconds
seconds = Tagged

toSeconds : DropsPerSecond -> Seconds
toSeconds (Tagged rate) =
  Tagged (1/rate)
    
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

isStrictlyNegative : Tagged a comparable -> Bool
isStrictlyNegative (Tagged n) = 
  n < 0
           
--- Support for tagging

type DropsPerSecondTag = DropsPerSecondTag UnusableConstructor
type SecondsTag = SecondsTag UnusableConstructor
type MinutesTag = MinutesTag UnusableConstructor
type HoursTag = HoursTag UnusableConstructor
type LitersTag = LitersTag UnusableConstructor
type PercentTag = PercentTag UnusableConstructor
type LitersPerMinuteTag = LitersPerMinuteTag UnusableConstructor
