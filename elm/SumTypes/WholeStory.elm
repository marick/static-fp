module SumTypes.WholeStory exposing (..)

-- import SumTypes.WholeStory exposing (..)

type Silly a b
  = AsInt Int
  | AsA a
  | AsB b
  | AlsoAsA a
  | AsIntString Int String
  | AsBoth a b
  | AsIntB Int b
  | AsMaybe (Maybe a)
  | AsMaybeInt (Maybe Int)
  | VerySilly (Silly a a) (Silly Int b)
  | NoArg


whyNotBoth : a -> b -> Silly a b
whyNotBoth a b =
  AsBoth a b
  
intFirst  : Int -> b    -> Silly Int b
intFirst a b =
  AsBoth a b

intSecond : a   -> Int  -> Silly a   Int
intSecond a b =
  AsBoth a b

intBool   : Int -> Bool -> Silly Int Bool
intBool a b =
  AsBoth a b

