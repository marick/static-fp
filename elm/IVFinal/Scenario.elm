module IVFinal.Scenario exposing (..)

import IVFinal.Measures as Measure
import Tagged exposing (Tagged(..))
import IVFinal.Util.AppTagged exposing (UnusableConstructor)


type alias LitersPerMinute = Tagged LitersPerMinuteTag Float

type alias Scenario = 
  { animal : String
  , bagType : String
  , containerVolume : Measure.Liters
  , startingFluid : Measure.Liters
  , dropsPerMil : Int
  }

carboy =
  { animal = "a 1560 lb 3d lactation purebred Holstein"
  , bagType = "5-gallon carboy"
  , containerVolume = Measure.liters 20.0
  , startingFluid = Measure.liters 19.0
  , dropsPerMil = 15
  }



justMinutes : Measure.Hours -> Measure.Minutes -> Measure.Minutes
justMinutes (Tagged hourPart) (Tagged minutePart) =
  Measure.minutes <| 60 * hourPart + minutePart

litersOverTime : LitersPerMinute -> Measure.Minutes -> Measure.Liters
litersOverTime (Tagged lpm) (Tagged minutes) =
  lpm * (toFloat minutes) |> Measure.liters



containerVolume : Measure.Liters
containerVolume = Measure.liters 20.0

startingFluid : Measure.Liters
startingFluid = Measure.liters 19.0

minusMinus : Tagged a Float -> Tagged a Float -> Tagged a Float -> Tagged a Float
minusMinus (Tagged x) (Tagged y) (Tagged z) =
  Tagged (x - y - z)

findLevel
    : Measure.DropsPerSecond
    -> Measure.Minutes
    -> Measure.Liters
findLevel dropsPerSecond minutes =
  let 
    litersPerMinute = flowRate dropsPerSecond
    litersDrained = litersOverTime litersPerMinute minutes
  in
    minusMinus containerVolume startingFluid litersDrained

    
--
flowRate : Measure.DropsPerSecond -> LitersPerMinute
flowRate (Tagged dropsPerSecond) =
  let
    dropsPerMil = 15.0
    milsPerSecond = dropsPerSecond / dropsPerMil
    milsPerHour = milsPerSecond * 60.0
  in
    Tagged <| milsPerHour / 1000.0 

type LitersPerMinuteTag = LitersPerMinuteTag UnusableConstructor
