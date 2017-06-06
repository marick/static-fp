module IvArchitecture.Common.Measures exposing (..)

import Tagged exposing (Tagged(..))
import IvArchitecture.Common.Tagged exposing (UnusableConstructor)

type alias DropsPerSecond = Tagged DropsPerSecondTag Float

dripRate : Float -> DropsPerSecond
dripRate = Tagged

--- Support for tagging

type DropsPerSecondTag = DropsPerSecondTag UnusableConstructor

