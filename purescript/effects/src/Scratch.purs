module Scratch where

{-
    You can paste all of these imports into the repl.
    To keep `pulp build` from whining, the equivalents
    outside this comment use explicit imports

import Control.Monad.Eff
import Control.Monad.Eff.Random
import Control.Monad.Eff.Console
import Control.Apply
import Control.Applicative
import Data.Tuple
import Data.Int
import Data.Either
import Data.Bifunctor
import Debug.Trace

-}

import Prelude
import Control.Monad.Eff
import Control.Monad.Eff.Random
-- import Control.Monad.Eff.Console
import Control.Apply
-- import Control.Applicative
import Data.Tuple
-- import Data.Int
-- import Data.Either
-- import Data.Bifunctor
-- import Debug.Trace



{- Creating an effect to produce a tuple of random numbers. -}

randomTuple :: Eff _ (Tuple Int Int)
randomTuple = lift2 Tuple (randomInt 1 10) (randomInt 100 10000)

secondRandom :: Eff _ Int
secondRandom = map snd randomTuple











-- negatedSnd :: Eff _ Int
-- negatedSnd = randomTuple <#> snd <#> negate


-- summed :: Eff _ Int
-- summed =
--   let
--     sumTuple (Tuple a b) = a + b
--   in
--     randomTuple <#> sumTuple

-- bySeven :: Eff _ Boolean
-- bySeven =
--   let
--     divisible n =
--       mod n 7 == 0
--   in
--    randomInt 0 100 <#> divisible

-- onlyEven :: Int -> Int
-- onlyEven n =
--   case even n of
--     true ->
--       n

--     false ->
--       n + 1
--         # onlyEven

-- -- forceEven n =
-- --   case even n of
-- --     true -> pure n 
-- --     false -> randomInt 0 100 >>= forceEven
      
-- -- forceEven :: Eff _ Int -> Eff _ Int
-- -- forceEven eff =
-- --   let
-- --     helper :: Int -> Eff _ Int
-- --     helper n =
-- --       case even n of
-- --         true -> pure n
-- --         false -> eff >>= helper
-- --   in
-- --    eff >>= helper

-- untilEven :: Eff _ Int -> Eff _ Int
-- untilEven eff =
--   let
--     onlyEven :: Int -> Eff _ Int
--     onlyEven n = 
--       case even n of
--         true -> pure n
--         false -> (debugEff "retry" eff) >>= onlyEven
--   in
--    (debugEff "first try" eff) >>= onlyEven


-- debugLog :: forall a . Show a => String -> a -> Eff _ Unit
-- debugLog tag value =
--   log $ tag <> ": " <> show value


-- debugEff :: forall a . Show a => String -> Eff _ a -> Eff _ a
-- debugEff tag eff =
--   eff 
--     >>= (\value ->
--            debugLog tag value
--               >>= (\_ ->
--                     pure value
--                   )
--         )

    
-- retainFirst :: forall lifted a b . Apply lifted =>
--        lifted a -> lifted b -> lifted a
-- retainFirst keep discard =
--   const <$> keep <*> discard
  
    
-- retainSecond :: forall lifted a b . Apply lifted =>
--        lifted a -> lifted b -> lifted b
-- retainSecond = flip retainFirst
  
    





-- debugEff2 :: forall a . Show a => String -> Eff _ a -> Eff _ a
-- debugEff2 tag eff =
--   do
--     value <- eff
--     _ <- debugLog tag value
--     pure value

-- debugEff3 :: forall a . Show a => String -> Eff _ a -> Eff _ a
-- debugEff3 tag eff =
--   eff 
--     >>= \value ->
--            debugLog tag value *> pure value
        

    


-- -- chattyUntilEven :: Eff _ Int -> Eff _ Int
-- -- chattyUntilEven eff =
-- --   let
-- --     onlyEven :: Int -> Eff _ Int
-- --     onlyEven n = 
-- --       case even n of
-- --         true -> pure n
-- --         false -> logShow n *> eff >>= onlyEven
-- --   in
-- --    eff >>= onlyEven



-- chattyUntilEven :: Eff _ Int -> Eff _ Int
-- chattyUntilEven eff =
--   let
--     onlyEven :: Int -> Eff _ Int
--     onlyEven n = 
--       case even n of
--         true -> pure n
--         false -> chattyUntilEven eff
--   in
--    eff >>= onlyEven



-- label :: forall a . (a -> Boolean) -> a -> Either a a 
-- label f x =
--   case f x of
--     true -> Right x
--     false -> Left x


-- untilV :: forall a . Show a => (a -> Either a a) -> Eff _ a -> Eff _ a
-- untilV labeller eff =
--   let
--     try :: a -> Eff _ a
--     try =
--       labeller >>> either (const $ untilV labeller eff) pure
--   in
--    eff >>= try



-- -- untilE :: Eff _ Int -> Eff _ Int
-- -- untilE eff =
-- --   let
-- --     try :: Int -> Eff _ Int
-- --     try =
-- --       label even >>> either (const $ untilE eff) pure
-- --   in
-- --    debugLog eff >>= try






-- -- trace tag n =
-- --   let
-- --     formatter =
-- --       print $ string <<< s ": " <<< int
-- --   in
-- --    formatter tag n # log


-- toTuple :: Eff _ Int -> Eff _ (Tuple Int Int)
-- toTuple eff =
--   eff >>= \a -> Tuple a 5 # pure
