module ToInt.ChainablyClassifiable exposing
  ( ChainablyClassifiable(..)
  , unclassified
  , mightBe
  , elseMustBe
  , rework
  , reworkMaybe
  , reworkResult
  )


type ChainablyClassifiable target classification workingValue 
  = Known classification
  | Unknown target workingValue

unclassified : a -> ChainablyClassifiable a classification a
unclassified target =
  Unknown target target
    
mightBe : (workingValue -> Bool) -> (target -> classification) 
        -> ChainablyClassifiable target classification workingValue 
        -> ChainablyClassifiable target classification workingValue
mightBe predicate tag checkable =
  case checkable of
    Known _ ->
      checkable
    Unknown target workingValue ->
      case predicate workingValue of
        True ->
          Known (tag target)
        False ->
          checkable

rework : (workingValueIn -> workingValueOut)
       -> ChainablyClassifiable a b workingValueIn
       -> ChainablyClassifiable a b workingValueOut
rework f incoming =
  case incoming of
    Known classified ->
      Known classified
    Unknown target workingValue ->
      Unknown target (f workingValue)

reworkMaybe : (workingValueIn -> Maybe workingValueOut)
            -> (target -> classification)
            -> ChainablyClassifiable target classification workingValueIn
            -> ChainablyClassifiable target classification workingValueOut
reworkMaybe f nothingTag incoming = 
  case incoming of
    Known classified ->
      Known classified
    Unknown target workingValue ->
      case f workingValue of
        Nothing ->
          Known (nothingTag target)
        Just newWorkingValue ->
          Unknown target newWorkingValue
               
reworkResult : (workingValueIn -> Result err workingValueOut)
            -> (target -> classification)
            -> ChainablyClassifiable target classification workingValueIn
            -> ChainablyClassifiable target classification workingValueOut
reworkResult f nothingTag incoming = 
  case incoming of
    Known classified ->
      Known classified
    Unknown target workingValue ->
      case f workingValue of
        Err _ ->
          Known (nothingTag target)
        Ok newWorkingValue ->
          Unknown target newWorkingValue
               
elseMustBe : (target -> classification)
           -> ChainablyClassifiable target classification workingValue
           -> classification
elseMustBe tag checkable =
  case checkable of
    Known classified -> classified
    Unknown target _ -> tag target

