module Errors.Lens.Error exposing (..)

import Lens.Try3.Lens exposing (..)
import Tagged exposing (Tagged(..))
import Lens.Try3.Helpers as H
import Dict exposing (Dict)
import Lens.Try3.Dict as Dict


{-                  Error Lenses               -}

type ErrorTag = ErrorTag IsUnused
type alias Error err big small =
  Tagged ErrorTag
    { get : big -> Result err small
    , set : small -> big -> big
    , update : (small -> small) -> big -> big
    }

error : (big -> Result err small) -> (small -> big -> big) -> Error err big small
error get set =
  let
    update f big =
      case get big of
        Err _ ->
          big
        Ok small ->
          set (f small) big
  in
    Tagged { get = get, set = set, update = update }
  

humbleToError : (big -> err)
            -> Humble big small
            -> Error err big small
humbleToError errMaker (Tagged lens) =
  let 
    get big =
      case lens.get big of
        Just x -> Ok x
        Nothing -> Err <| errMaker big
  in
    Tagged
      { get = get
      , set = lens.set
      , update = lens.update
      }

fromMaybe : (big -> err)
          -> (big -> Maybe small)
          -> (small -> big -> big)
          -> Error err big small
fromMaybe errMaker get set =
  humble get set |> humbleToError errMaker

errorAndError : Error err a b -> Error err b c -> Error err a c
errorAndError (Tagged a2b) (Tagged b2c) =
  let 
    get a =
      case a2b.get a of
        Ok b -> b2c.get b
        Err e -> Err e
                  
    set c a =
      case a2b.get a of
        Ok b ->
          a2b.set (b2c.set c b) a
        Err _ -> a
  in
    error get set


    


setR : Error err big small -> small -> big -> Result err big
setR (Tagged lens) small big =
  case lens.get big of
    Ok _ -> Ok <| lens.set small big
    Err err -> Err err
  
updateR : Error err big small -> (small -> small) -> big -> Result err big
updateR (Tagged lens) f big =
  case lens.get big of
    Ok small -> Ok <| lens.set (f small) big
    Err err -> Err err


    
type IsUnused = IsUnused IsUnused
