module Scratch where

import Prelude

import Data.List as List
import Data.List (List)

import Data.Array
import Data.Maybe
import Data.Tuple

-- import Data.Array 

intList :: List Int
intList = List.singleton 555

intArray :: Array Int
intArray = singleton 3  -- `singleton` imported from `Data.Array`

-- Note that type annotation isn't required
tuple = Tuple 1 2.3


-- cases :: Int -> Int -> Int
cases 0 0 = 10
cases 0 1 = -1
cases _ 3 = -3
cases 8 _ = -8
-- cases x y = x + y


xy = cases 888 888  

data MyType wrapped = First wrapped | Second

instance showMyType :: Show wrapped => Show (MyType wrapped) where
  show (First x) = "(First " <> show x <> ")"
  show Second  = "Second"


type Point = {x :: Int, y :: Number}

point :: Int -> Number -> Point
point = { x : _ , y : _ }


step next x = next $ x + 1

calc mx =
  bind mx (step Just)

-- type Point record = { x :: Number , y :: Number | record } 

-- p :: Point ()
-- p = {x : 1.1 , y : 2.2 }

-- type ColorfulPoint = Point (color :: String)


-- point :: Number -> Number -> Point ()
-- point x y =
--   {x : x , y : y }


-- f :: forall whole . Point whole -> Number
-- f {x,y} = x + y 
