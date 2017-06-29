module IVFinal.Scenario exposing
  ( Scenario
  , carboy
  )

import IVFinal.Util.Measures as Measure
import Tagged exposing (Tagged(..))

type alias Scenario = 
  { animal : String
  , bagType : String
  , containerVolume : Measure.Liters
  , startingFluid : Measure.Liters
  , dropsPerMil : Int
  }

carboy : Scenario  
carboy =
  { animal = "a 1560 lb 3d lactation purebred Holstein"
  , bagType = "5-gallon carboy"
  , containerVolume = Measure.liters 20.0
  , startingFluid = Measure.liters 19.0
  , dropsPerMil = 15
  }

