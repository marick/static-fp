module Lens.Try4.Result exposing
  ( ok
  , err
  )

import Lens.Try4.Lens as Lens

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

