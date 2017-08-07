module IVBits.FixedStringSupport exposing (..)

type ChainablyClassifiable target classification workingCopy 
  = Known classification
  | Unknown target workingCopy

mightBe : (workingCopy -> Bool)
        -> (target -> classification) 
         -> ChainablyClassifiable target classification workingCopy 
         -> ChainablyClassifiable target classification workingCopy
mightBe predicate constructor checkable =
  case checkable of
    Known _ ->
      checkable
    Unknown target workingCopy ->
      case predicate workingCopy of
        True ->
          Known (constructor target)
        False ->
          checkable

rework : (workingCopyIn -> workingCopyOut)
       -> ChainablyClassifiable a b workingCopyIn
       -> ChainablyClassifiable a b workingCopyOut
rework f incoming =
  case incoming of
    Known classified ->
      Known classified
    Unknown target workingCopy ->
      Unknown target (f workingCopy)
         
            
elseMustBeBe : (target -> classification)
            -> ChainablyClassifiable target classification workingCopy
            -> classification
elseMustBeBe constructor checkable =
  case checkable of
    Known classified -> classified
    Unknown target _ -> constructor target

type Classified a 
  = PreemptivelyBogus a
  | SuitableForToInt a
  | TooLong a
  | BoundaryNegative a
  | BoundaryPositive a

type alias SignedString =
  { negative : Bool
  , string : String
  }

preemptivelyBogus string =
  List.any (\bad -> string == bad) ["", "-", "+"]
  || List.any (\bad -> String.left 2 string == bad) ["--", "++"]

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

maxInt =  2147483647
minInt = -2147483648
boundary = maxInt |> toString |> String.length

nicelyShort : SignedString -> Bool
nicelyShort signed =
  String.length signed.string < boundary

definitelyTooLong : SignedString -> Bool
definitelyTooLong signed =
  String.length signed.string > boundary

classify : String -> Classified String
classify string =
  Unknown string string
    |> mightBe preemptivelyBogus PreemptivelyBogus
    |> rework separateSign
    |> mightBe nicelyShort SuitableForToInt
    |> mightBe definitelyTooLong TooLong
    |> mightBe .negative BoundaryNegative
    |> elseMustBeBe BoundaryPositive

