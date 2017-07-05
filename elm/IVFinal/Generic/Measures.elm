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
  , litersOverTime
  , timeRequired
  , seconds
  , toSeconds
  , minutes
  , hours
  , toMinutes
  , fromMinutes
  , friendlyMinutes
  , percent
  , proportion

  , negate
  , reduceBy
  , isStrictlyNegative
  , isStrictlyPositive
  )

{-| A variety of units implemented as tagged types, together with their
constructors and conversion functions. 

`DropsPerSecond` isn't actually generic, but it's too much of a hassle to
put it somewhere else.
-}

import IVFinal.Generic.Tagged exposing (UnusableConstructor)
import Tagged exposing (Tagged(Tagged))
import String.Extra as String

--
type alias Liters = Tagged LitersTag Float

liters : Float -> Liters
liters = Tagged

--
type alias DropsPerSecond = Tagged DropsPerSecondTag Float

dripRate : Float -> DropsPerSecond
dripRate = Tagged

toSeconds : DropsPerSecond -> Seconds
toSeconds (Tagged rate) =
  Tagged (1/rate)
    
--            
type alias LitersPerMinute = Tagged LitersPerMinuteTag Float

litersPerMinute : Float -> LitersPerMinute
litersPerMinute = Tagged

litersOverTime : LitersPerMinute -> Minutes -> Liters
litersOverTime (Tagged lpm) (Tagged minutes) =
  lpm * (toFloat minutes) |> liters

timeRequired : LitersPerMinute -> Liters -> Minutes
timeRequired (Tagged lmp) (Tagged liters) = 
  (1 / lmp) * liters |> round |> minutes

--

{- This is somewhat peculiar in that seconds are floats and
minutes and hours are ints. That's because the latter two
are for human consumption and the former is internal to the program.
-}

type alias Seconds = Tagged SecondsTag Float
type alias Minutes = Tagged MinutesTag Int
type alias Hours = Tagged HoursTag Int

seconds : Float -> Seconds
seconds = Tagged

minutes : Int -> Minutes
minutes = Tagged

hours : Int -> Hours
hours = Tagged

toMinutes : Hours -> Minutes -> Minutes
toMinutes (Tagged hourPart) (Tagged minutePart) =
  60 * hourPart + minutePart |> minutes

fromMinutes : Minutes -> (Hours, Minutes)
fromMinutes (Tagged source) =
  ( source // 60 |> hours
  , rem source 60 |> minutes
  )

friendlyMinutes : Minutes -> String
friendlyMinutes source =
  let
    (Tagged hours, Tagged minutes) = fromMinutes source
    outMinutes = String.pluralize "minute" "minutes" minutes
    outHours = String.pluralize "hour" "hours" hours
  in
    case (hours, minutes) of
      (0, 0) -> outMinutes
      (_, 0) -> outHours
      (0, _) -> outMinutes
      _ -> outHours ++ " and " ++ outMinutes


--
type alias Percent = Tagged PercentTag Float

percent : Float -> Percent
percent = Tagged

proportion : Tagged a Float -> Tagged a Float -> Percent
proportion (Tagged first) (Tagged second) =
  percent (first / second)

  
-- Functions that apply to generic types

{-| Apply a binary function to two numbers.

    changeBy (-) (minutes 10) (minutes 1) == minutes 9

-}
changeBy : (number -> number -> number)
        -> Tagged a number -> Tagged a number
        -> Tagged a number
changeBy f decrement value =
  Tagged.map2 f value decrement

reduceBy : Tagged a number -> Tagged a number -> Tagged a number
reduceBy = changeBy (-)

negate : Tagged a number -> Tagged a number
negate value =
  Tagged.map (\n -> -n) value

isStrictlyNegative : Tagged a comparable -> Bool
isStrictlyNegative (Tagged n) = 
  n < 0
           
isStrictlyPositive : Tagged a comparable -> Bool
isStrictlyPositive (Tagged n) = 
  n > 0
           
--- Support for tagging

type DropsPerSecondTag = DropsPerSecondTag UnusableConstructor
type SecondsTag = SecondsTag UnusableConstructor
type MinutesTag = MinutesTag UnusableConstructor
type HoursTag = HoursTag UnusableConstructor
type LitersTag = LitersTag UnusableConstructor
type PercentTag = PercentTag UnusableConstructor
type LitersPerMinuteTag = LitersPerMinuteTag UnusableConstructor
