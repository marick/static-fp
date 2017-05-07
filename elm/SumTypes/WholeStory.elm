module SumTypes.WholeStory exposing (..)

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

sample =
  DeeplySilly
    (DeeplySilly
       (AsMaybe (Just []))
       (AsIntB 3 []))
    (AsInt 3)
