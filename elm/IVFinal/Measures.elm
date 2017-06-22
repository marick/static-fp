module IVFinal.Measures exposing
  ( DropsPerSecond
  , TimePerDrop

  , dripRate
  , rateToDuration
  , reduceBy
  )

import Tagged exposing (Tagged(..), untag, retag)
import IVFinal.Util.AppTagged exposing (UnusableConstructor)
import Time

dripRate : Float -> DropsPerSecond
dripRate = Tagged

rateToDuration : DropsPerSecond -> TimePerDrop
rateToDuration dps =
  let
    calculation rate =
      (1 / rate ) * Time.second
  in
    Tagged.map calculation dps |> retag

reduceBy : TimePerDrop -> TimePerDrop -> TimePerDrop
reduceBy smaller larger =
  Tagged.map2 (-) larger smaller

--- Support for tagging

type alias DropsPerSecond = Tagged DropsPerSecondTag Float
type DropsPerSecondTag = DropsPerSecondTag UnusableConstructor

type alias TimePerDrop = Tagged TimePerDropTag Float
type TimePerDropTag = TimePerDropTag UnusableConstructor

