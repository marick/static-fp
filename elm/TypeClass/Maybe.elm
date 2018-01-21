module TypeClass.Maybe exposing (..)

{- Support for Monoids -} 

empty : Maybe a
empty = Nothing

append_left : Maybe a -> Maybe a -> Maybe a
append_left left right =
  case left of
    Nothing -> right
    _ -> left


append_right : Maybe a -> Maybe a -> Maybe a
append_right left right =
  case right of
    Nothing -> left
    _ -> right
         
