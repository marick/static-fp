module IVFinal.Scenario exposing
  ( Scenario
  , carboy
  )

import IVFinal.Generic.Measures as Measure

type alias Scenario = 
  { animal : String
  , bagType : String
  , containerVolume : Measure.Liters
  , startingVolume : Measure.Liters
  , dropsPerMil : Int
  }

carboy : Scenario  
carboy =
  { animal = "a 1560 lb 3d lactation purebred Holstein"
  , bagType = "5-gallon carboy"
  , containerVolume = Measure.liters 20.0
  , startingVolume = Measure.liters 19.0
  , dropsPerMil = 15
  }

