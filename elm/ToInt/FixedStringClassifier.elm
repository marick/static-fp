module ToInt.FixedStringClassifier exposing
  ( Classified(..)
  , classify
  , lengthBoundary
  )

import ToInt.ChainablyClassifiable exposing (..)

{- Below this boundary, use `toInt`. At the boundary, special
   calculations are needed. Above it: error
-}

lengthBoundary = 10

type Classified a 
  = PreemptivelyBogus a
  | SuitableForToInt a
  | TooLong a
  | BoundaryNegative a
  | BoundaryPositive a

classify : String -> Classified String
classify string =
  unclassified string 
    |> mightBe preemptivelyBogus PreemptivelyBogus
    |> reworkMaybe separateSign PreemptivelyBogus
    |> mightBe nicelyShort SuitableForToInt
    |> mightBe definitelyTooLong TooLong
    |> mightBe .negative BoundaryNegative
    |> elseMustBe BoundaryPositive

type alias SignedString =
  { negative : Bool
  , string : String
  }


preemptivelyBogus string =
  List.any (\bad -> string == bad) ["", "-", "+"]
  || List.any (\bad -> String.left 2 string == bad) ["--", "++", "-+", "+-"]

separateSign : String -> Maybe SignedString
separateSign string =
  let
    classify (sign, remainder) = 
      case sign of
        '-' -> { negative = True,  string = remainder }
        '+' -> { negative = False, string = remainder }
        _   -> { negative = False, string = string }
  in
    String.uncons string
      |> Maybe.map classify

nicelyShort : SignedString -> Bool
nicelyShort signed =
  String.length signed.string < lengthBoundary

definitelyTooLong : SignedString -> Bool
definitelyTooLong signed =
  String.length signed.string > lengthBoundary

