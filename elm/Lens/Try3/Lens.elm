module Lens.Try3.Lens exposing (..)


import Tagged exposing (Tagged(..))
import Maybe.Extra as Maybe

{- By radically widening the types, we can have `get`, `set`, and
   `update` that work with different kinds of lenses.
-}
type alias Generic r getter setter updater =
  { r
    | get : getter
    , set : setter
    , update : updater
  }

get : Tagged tag (Generic r getter setter updater) -> getter
get (Tagged lens) =
  lens.get

set : Tagged tag (Generic r getter setter updater) -> setter
set (Tagged lens) =
  lens.set

update : Tagged tag (Generic r getter setter updater) -> updater
update (Tagged lens) =
  lens.update


{- Handling Maybe -}

-- A generic type for all lenses whose getters return `Maybe`.
type alias GenericMaybe r big small setter updater =
  Generic r (big -> Maybe small) setter updater 

exists : Tagged tag (GenericMaybe r big small setter updater)
       -> big -> Bool
exists (Tagged lens) whole =
  lens.get whole |> Maybe.isJust
  
{-                  Classic Lenses             -}

type ClassicTag = ClassicTag IsUnused
type alias Classic big small =
  Tagged ClassicTag
    { get : big -> small
    , set : small -> big -> big
    , update : (small -> small) -> big -> big
    }

classic : (big -> small) -> (small -> big -> big) -> Classic big small
classic get set =
  let 
    update f big =
      get big |> f |> flip set big
  in
    Tagged { get = get, set = set, update = update }

      
      
{-                  Upsert Lenses               -}

type UpsertTag = UpsertTag IsUnused
type alias Upsert big small =
  Tagged UpsertTag
    { get : big -> Maybe small
    , set : Maybe small -> big -> big
    , update : (small -> small) -> big -> big
    }

upsert : (big -> Maybe small)
      -> (small -> big -> big)
      -> (big -> big)          -- separate `delete` function
      -> Upsert big small
upsert get upserter remove =
  let
    set maybe = 
      case maybe of
        Nothing ->
          remove
        Just val -> 
          upserter val
  in
    upsert2 get set

upsert2 : (big -> Maybe small)
        -> (Maybe small -> big -> big)
        -> Upsert big small
upsert2 get set =           
  let
    update f = guardedUpdate get set (f >> Just)
  in
    Tagged
    { get = get
    , set = set
    , update = update
    }

getWithDefault : Tagged tag (GenericMaybe r big small setter updater)
               -> small -> big -> Maybe small    
getWithDefault (Tagged lens) default big =
  case lens.get big of
    Nothing -> Just default
    actual -> actual


               
updateWithDefault : Upsert big small -> small -> (small -> small)
                  -> big -> big
updateWithDefault (Tagged lens) default f big =
  let
    gotten =
      case lens.get big of
        Nothing -> default
        (Just small) -> small
  in
    lens.set (f gotten |> Just) big
      

{-                  Humble Lenses               -}

type HumbleTag = HumbleTag IsUnused
type alias Humble big small =
  Tagged HumbleTag
    { get : big -> Maybe small
    , set : small -> big -> big
    , update : (small -> small) -> big -> big
    }

humble : (big -> Maybe small)
       -> (small -> big -> big)
       -> Humble big small
humble get set =
  Tagged
  { get = get
  , set = set
  , update = guardedUpdate get set
  }

setM : Humble big small -> small -> big -> Maybe big
setM (Tagged lens) small big =
  case lens.get big of
    Nothing -> Nothing
    Just _ -> Just <| lens.set small big
    

updateM : Humble big small -> (small -> small) -> big -> Maybe big
updateM (Tagged lens) f big =
  case lens.get big of
    Nothing -> Nothing
    Just small -> Just <| lens.set (f small) big
    

{-                  OneCase Lenses               -}

type OneCaseTag = OneCaseTag IsUnused
type alias OneCase big small =
  Tagged OneCaseTag
    { get : big -> Maybe small
    , set : small -> big
    , update : (small -> small) -> big -> big
    }

oneCase : (big -> Maybe small)
        -> (small -> big)
        -> OneCase big small
oneCase get set =
  let
    update f big =
      case get big of
        Nothing ->
          big
        Just small ->
          set (f small)
  in
    Tagged
    { get = get
    , set = set
    , update = update
    }

{-                  Alarmist Lenses               -}

type alias AlarmistResult whole ok =
  Result { whole : whole, path : (List String) } ok

type AlarmistTag = AlarmistTag IsUnused
type alias Alarmist big small =
  Tagged AlarmistTag
    { name : String
    , get : big -> AlarmistResult big small
    , set : small -> big -> AlarmistResult big big
    , update : (small -> small) -> big -> AlarmistResult big big
    }

alarmist : tag -> (big -> Maybe small) -> (small -> big -> big)
         -> Alarmist big small
alarmist tag baseGet baseSet =
  let
    name = pathComponentName tag

    get big =
      case baseGet big of
        Nothing -> Err {whole = big, path = [name]}
        Just small -> Ok small

    set small big =
      case get big of
        Err e -> Err e
        Ok _ -> Ok <| baseSet small big
      
    update f big =
      case get big of
        Err e -> Err e
        Ok small -> Ok <| baseSet (f small) big
  in
    Tagged { name = pathComponentName tag
           , get = get
           , set = set
           , update = update
           }

pathComponentName : a -> String
pathComponentName x =
  "`" ++ toString x ++ "`"


    
{-                 Util                        -}


{- Upsert and Humble lenses construct their `update` functions the same way. -}
guardedUpdate : (big -> Maybe small)
              -> (transformed -> big -> big)
              -> (small -> transformed) -> big -> big
guardedUpdate get set f big =
  case get big of
    Nothing ->
      big
    Just small ->
      set (f small) big



type IsUnused = IsUnused IsUnused
