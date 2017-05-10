module SumTypes.PhantomTagging exposing (..)

module SumTypes.PhantomTagging exposing (..)

-- The core trick:

type Tagged tag value = Tagged value


----- Uses  

type DripRate = UnusedDripRateConstructor
type Percent = UnusedPercentConstructor

dripRate : Float -> Tagged DripRate Float
dripRate = Tagged 

percent : Float -> Tagged Percent Float
percent  = Tagged 
             
