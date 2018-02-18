module Random where

import Prelude

import Data.Array as Array
import Data.Array hiding ((:))
import Data.Maybe
import Data.Tuple
import Data.List
import Data.List as List
import Data.List hiding (fromFoldable)
import Data.Foldable

import Control.Monad 
import Control.Monad.Eff
import Control.Monad.Eff.Random
import Control.Monad.Eff.Now
import Control.Monad.Eff.Console
import Control.Apply
import Data.Int
import Data.Monoid
import Data.Unfoldable as Unfold


{-

(apply (map Tuple random) random)
Tuple <$> random <*> random



-}

doit true = log "even"
doit false = log "even"

sign n = 
  case even n of
    true -> "even"
    false -> "odd"

-- randomInt 1 3 <#> sign) >>= log


doish = 
  do
    n <- randomInt 1 5
    let output = sign n
    log output 


-- list1 :: List Int -> List Int -> Array Int

logParity :: Int -> Eff _ Unit
logParity x =
  if even x then
    logShow "true"
  else
    logShow "false"

showParity :: Boolean -> Eff _ Unit
showParity true = logShow "true"
showParity false = logShow "false"



twoDigitInts :: Eff _ Unit 
twoDigitInts =
  candidate >>= stopIfSmall []
  where
    candidate :: Eff _ (Tuple Int Boolean)
    candidate =
      randomInt 0 99 <#> (\x -> Tuple x (x > 9))

    stopIfSmall :: Array Int -> (Tuple Int Boolean) -> Eff _ Unit
    stopIfSmall acc (Tuple _ false) = logShow acc
    stopIfSmall acc (Tuple value _) =
      candidate >>= stopIfSmall (Array.snoc acc value)
  
  
  
-- logAcc acc x =
--   if even x then
--     logAcc (Array.snoc acc x) (randomInt 0 333)
--   else
--     logShow acc

    


efficiently :: forall a b lifted.
               (List a -> List b) -> Array a -> Array b
efficiently f = 
  List.fromFoldable >>> f >>> List.reverse >>> Array.fromFoldable

    

beforeOdd :: Array Int -> Array Int
beforeOdd = efficiently (accumulate Nil) 
  where
  accumulate :: List Int -> List Int -> List Int
  accumulate acc Nil = acc
    
  accumulate acc (head : tail)
    | even head = accumulate (head : acc) tail
    | otherwise = acc





plusC x y next =
  x + y # next

timesC x y next =
  x * y # next




-- m a b =
--   do
--     sum <- a + b
--     prod <- a * b
--     Just $ sum + prod




-- addM :: forall m . Monad m => m Int -> m Int -> m (Tuple Int Int)
-- addM mx my = do
--   x <- mx
--   y <- my
--   let
--     sum = x + y
--     prod = x * y
--   in 
--     pure $ Tuple sum prod

calc :: Int -> Int -> Int
calc x y =
  let
    sum = x + y
    sub = x - sum
  in
    sum * sub


calc1 :: Int -> Int -> Int
calc1 x y =
  x + y # (\sum ->
             let
               sub = x - sum
             in
               sum * sub)

calc2 :: Int -> Int -> Int
calc2 x y =
  x + y # (\sum ->
             x - sum # (\sub -> 
                           sum * sub))

  
      
      


-- calc3b :: Maybe Int -> Maybe Int -> Maybe Int
-- calc3b x y =
--   x + y >>= (\sub ->
--               x - y >>= (\sum ->
--                           Just $ sum * sub))

-- calc4 :: Maybe Int -> Maybe Int -> Maybe Int
-- calc4 mx my =
--   mx >>= \x ->
--   my >>= \y -> 
--     x + y >>= (\sub ->
--                 x - y >>= (\sum ->
--                             Just $ sum * sub))



-- calc5 :: Maybe Int -> Maybe Int -> Maybe Int
-- calc5 x y =
--     Just (x + y) >>= (\sub ->
--                 Just (x - y) >>= (\sum ->
--                             Just $ sum * sub))

safeDiv :: Int -> Int -> Maybe Int
safeDiv a b =
  case b of
    0 -> Nothing
    _ -> Just $ a / b


safeDivF :: Maybe Int -> Maybe Int -> Maybe Int
safeDivF ma mb =
  ma >>= \a -> (mb >>= \b -> safeDiv a b)

safeDivF1 :: Maybe Int -> Maybe Int
safeDivF1 mb = 
  mb >>= safeDiv 7

safeDivF2 :: Maybe Int -> Maybe Int
safeDivF2 mb = 
  mb >>= (\b -> safeDiv 7 b)


  
safeDivM :: Maybe Int -> Maybe Int -> Maybe Int
safeDivM ma mb =
  do
    a <- ma
    b <- mb
    safeDiv a b 


multM ma mb = 
  do
    a <- ma
    b <- mb
    let sum = a + b
    let prod = a * b
    Just $ [sum, prod, prod - sum]


multM ma mb = 
  do
    a <- ma
    b <- mb
    let sum = a + b
    let prod = a * b
    Just $ [sum, prod, prod - sum]

multMG ma mb =  -- Use with Maybe Either
  do
    a <- ma
    b <- mb
    let sum = a + b
    let prod = a * b
    pure $ [sum, prod, prod - sum]





-- Just 4 >>= Just 3 >> safeDiv
-- Just 4 >>= (\a -> Just 3 >>= safeDiv a)


f ma mb =
  do
    a <- ma
    b <- mb
    let sum = a + b
    let prod = a * b
    pure $ [sum, prod, prod - sum]
