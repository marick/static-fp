module Lens.Try3.Result exposing
  ( ok
  , err
  )

import Lens.Try3.Lens as Lens

ok : Lens.OneCase (Result err ok) ok
ok =
  Lens.oneCase Result.toMaybe Ok

err : Lens.OneCase (Result err ok) err
err =
  let
    get big =
      case big of
        Err e -> Just e
        _  -> Nothing
  in
    Lens.oneCase get Err

