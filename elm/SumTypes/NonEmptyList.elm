module SumTypes.NonEmptyList exposing (..)

type NonEmptyList a =
  NonEmptyList a (List a)

length : NonEmptyList a -> Int
length (NonEmptyList _ xs) =
  1 + List.length xs
