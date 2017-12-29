module Lens.Final.PathShared exposing (..)

quote : a -> String
quote x =
  "`" ++ toString x ++ "`"

