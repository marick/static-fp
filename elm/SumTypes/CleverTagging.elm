module SumTypes.CleverTagging exposing (..)

type Tagged tag value
  = Tagged value

type CountTag = CountTag
type IdTag = IdTag

type alias Count = Tagged CountTag Int
type alias Id = Tagged IdTag String   
  
makeCount : Int -> Count
makeCount = Tagged

makeId : String -> Id
makeId = Tagged

type Pair = Pair Count Id

-- Pair (makeCount 3) (makeId "dawn")
-- Pair (makeCount 3) (makeCount 4)
