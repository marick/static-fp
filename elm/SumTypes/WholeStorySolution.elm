module SumTypes.WholeStorySolution exposing (..)

type Silly a b
  = AsA a
  | AsB b
  | AlsoAsA a

  | AsInt Int

  | AsFloatString Float String
  | AsBoth a b
  | AsIntB Int b

  | AsMaybe (Maybe b)
  | AsMaybeInt (Maybe Int)
  | DeeplySilly (Silly a a) (Silly Int b)
  | NoArg


simplify : Silly a b -> Silly a b
simplify silly =
  case silly of
    AsA _ -> silly
    AsB _ -> silly
    _ -> NoArg


bVals1 : Silly a b -> Maybe b
bVals1 silly =
  case silly of 
    AsB b -> Just b
    _ -> Nothing

bVals : Silly a b -> Maybe b
bVals silly =
  case silly of 
    AsB b -> Just b
    AsBoth _ b -> Just b
    AsIntB _ b -> Just b
    AsMaybe (Just b) -> Just b  -- could just be AsMaybe maybe -> maybe
    DeeplySilly _ nested -> bVals nested
    _ -> Nothing
         
