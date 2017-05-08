module SumTypes.NonEmptyList exposing (..)

type NonEmptyList a =
  NonEmptyList a (List a)

length : NonEmptyList a -> Int
length (NonEmptyList _ xs) =
  1 + List.length xs

map : (a -> b) -> NonEmptyList a -> NonEmptyList b
map f (NonEmptyList x xs) =
  NonEmptyList (f x) (List.map f xs)

head : NonEmptyList a -> a
head (NonEmptyList x _) = x

tail : NonEmptyList a -> Maybe (NonEmptyList a)
tail (NonEmptyList _ xs) =
  case xs of
    [] -> Nothing
    x :: xs -> Just (NonEmptyList x xs)
