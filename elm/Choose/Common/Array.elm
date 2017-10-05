module Choose.Common.Array exposing
  ( valueAt
  )

import Choose.MaybePart as MaybePart exposing (MaybePart)
import Array exposing (Array)

valueAt : Int -> MaybePart (Array val) val
valueAt key = 
  MaybePart.make (Array.get key) (Array.set key)
