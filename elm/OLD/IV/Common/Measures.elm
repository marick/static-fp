module IV.Common.Measures exposing (..)

import Tagged exposing (Tagged(..))
import IV.Common.Tagged exposing (UnusableConstructor)

type alias DropsPerSecond = Tagged DropsPerSecondTag Float

dripRate : Float -> DropsPerSecond
dripRate = Tagged

--- Support for tagging

type DropsPerSecondTag = DropsPerSecondTag UnusableConstructor

