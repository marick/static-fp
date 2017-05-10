module SumTypes.TaggedUse exposing (..)

import Tagged exposing (Tagged(..))

type DripRate = UnusedDripRateConstructor
type Percent = UnusedPercentConstructor

dripRate : Float -> Tagged DripRate Float
dripRate = Tagged

percent : Float -> Tagged Percent Float
percent = Tagged
