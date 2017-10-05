module Choose.Definitions exposing (..)

import Choose.Case as Case exposing (Case)
import Choose.Part as Part exposing (Part)
import Choose.MaybePart as Opt exposing (MaybePart)
import Dict exposing (Dict)

type SumType
  = Id Int
  | Name String
  | Both String Int
    
id = Case.make
     (\ whole ->
        case whole of
          Id id -> Just id
          _ -> Nothing)
     Id
       
name = Case.make
       (\ whole ->
          case whole of
            Name name -> Just name
            _ -> Nothing)
       Name

both = Case.make
       (\ whole ->
          case whole of
            Both s i -> Just (s, i)
            _ -> Nothing)
       (uncurry Both)


-- Nested sum types         

type TwoLevelSumType
  = One (Result String Int)
  | Two (Result String String)

chooseOne : Case TwoLevelSumType (Result String Int)   -- Focus on `One/Ok`
chooseOne = Case.make
      (\ big -> 
         case big of
           One little -> Just little
           _ -> Nothing)
      One

chooseTwo : Case TwoLevelSumType (Result String String)   -- Focus on `Two/Ok`
chooseTwo = Case.make
      (\ big -> 
         case big of
           Two little -> Just little
           _ -> Nothing)
      Two

chooseOk = Case.make Result.toMaybe Ok

-- Dictionary work
dict1 = Dict.singleton
dict1_1 outer inner val =
  dict1 outer (dict1 inner val)


-- Record work

oneLevelLens = Part.make .part (\part whole -> { whole | part = part })

