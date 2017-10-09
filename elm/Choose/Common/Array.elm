module Choose.Common.Array exposing
  ( valueAt
  )

import Choose.MaybeLens as MaybeLens exposing (MaybeLens)
import Array exposing (Array)

valueAt : Int -> MaybeLens (Array val) val
valueAt key = 
  MaybeLens.make (Array.get key) (Array.set key)
