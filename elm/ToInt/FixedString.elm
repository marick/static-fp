module IVBits.FixedString exposing
  (toInt
  )

{-| This module contains fixed versions of `String` functions.
-}

longestValid = maxInt |> toString |> String.length

maxInt =       2147483647
maxIntPrefix = 214748364
maxIntSuffix =          7

minInt =       -2147483648
minIntPrefix =  214748364
minIntSuffix =           8

type Sign = Negative | Positive

  

-- convertNegative s = ("-" ++ s) |> String.toInt |> Result.toMaybe

-- err input =
--   Err ("could not convert string '" ++ input ++ "' to an Int")


-- suitableString string =
--   let
--     two = String.left 2 string
--     bogus = string == "-"
--             || string == "+"
--             || two == "--"
--             || two == "++"
--   in
--     case bogus of
--       True -> Nothing
--       False -> Just string

-- type Classification
--   = Bogus String
--   | SuitableForToInt
--   | TooLong 
--   | Negative String
--   | Positive String 

-- classifyLength string =
  
  





--                assignSign string =
--   case String.left 1 string of
--     "+" -> String.
    
toInt : String -> Result String Int
toInt string = String.toInt string

-- -- toInt string =
-- --   let
-- --     maybeResult = 
-- --       case String.left 1 string of
-- --         "-" -> Nothing
-- --         _ -> convertPositive string
-- --   in
-- --     case maybeResult of
-- --       Nothing -> err string
-- --       Just result -> Ok result
