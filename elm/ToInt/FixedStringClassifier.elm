module ToInt.FixedStringClassifier exposing
  ( Classified(..)
  , classify
  , maxInt
  , minInt
  )

import ToInt.ChainablyClassifiable exposing (..)

maxInt =  2147483647
minInt = -2147483648

boundary = maxInt |> toString |> String.length

type Classified a 
  = PreemptivelyBogus a
  | SuitableForToInt a
  | TooLong a
  | BoundaryNegative a
  | BoundaryPositive a

classify : String -> Classified String
classify string =
  Unknown string string
    |> mightBe preemptivelyBogus PreemptivelyBogus
    |> rework separateSign
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

separateSign : String -> SignedString
separateSign string = 
  let
    sign = String.left 1 string
    remainder = String.dropLeft 1 string
  in
    case sign of
      "-" -> { negative = True,  string = remainder }
      "+" -> { negative = False, string = remainder }
      _   -> { negative = False, string = string }

nicelyShort : SignedString -> Bool
nicelyShort signed =
  String.length signed.string < boundary

definitelyTooLong : SignedString -> Bool
definitelyTooLong signed =
  String.length signed.string > boundary

