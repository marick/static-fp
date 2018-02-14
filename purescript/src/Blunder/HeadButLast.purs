module Blunder.HeadButLast where

import Prelude
import Data.Maybe
import Data.Array
import Data.String as String
import Data.String.Yarn as String


headButLast1 array =
  String.reverse <$> _.tail <$> (String.uncons =<< String.reverse <$> head array)

headButLast2 array =
  head array <#> String.reverse >>= String.uncons <#> _.tail <#> String.reverse

headButLast :: Array String -> Maybe String
headButLast array = 
  array 
     #  head
    <#> String.reverse
    >>= String.uncons
    <#> _.tail
    <#> String.reverse


headButLastPF :: Array String -> Maybe String
headButLastPF =
           head
  >>> map  String.reverse
  >=>      String.uncons
  >>> map  _.tail
  >>> map  String.reverse

composeLifted l r = l >>> map r
infixl 1 composeLifted as >#>

headButLastPF2 :: Array String -> Maybe String
headButLastPF2 =
      head
  >#> String.reverse
  >=> String.uncons
  >#> _.tail
  >#> String.reverse


