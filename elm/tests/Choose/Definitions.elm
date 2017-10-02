module Choose.Definitions exposing (..)

import Choose.Case as Case
import Choose.Part as Part
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
  | Two (Result String Float)

topLevelChoice = Case.make
      (\ big -> 
         case big of
           Two little -> Just little
           _ -> Nothing)
      Two

bottomLevelChoice = Case.make Result.toMaybe Ok


innerFloat = topLevelChoice |> Case.next bottomLevelChoice




---

-- Dictionary work
             
dict1 = Dict.singleton
dict1_1 outer inner val =
  dict1 outer (dict1 inner val)


-- Record work

oneLevelLens = Part.make .part (\part whole -> { whole | part = part })

