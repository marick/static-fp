module TypeClass.BitSequence exposing
  ( fromList
  , fromString
  , fromBool

  , empty
  , append
  )

type BitSequence = Bits String
  

-- Smart constructor
-- To make a simpler example, let's convert
-- invalid values into `empty` (a bad idea
-- in general).

fromList : List Char -> BitSequence
fromList list = 
  let
    isValidChar c =
      c == '0' || c == '1'

  in
    case List.all isValidChar list of
      True ->
        Bits <| String.fromList list
      False ->
        Bits ""

fromString : String -> BitSequence
fromString = String.toList >> fromList

fromBool : Bool -> BitSequence
fromBool b =
  case b of
    True -> Bits "1"
    False -> Bits "0"


-- instance Monoid BitSequence with 
empty : BitSequence
empty = Bits ""

append : BitSequence -> BitSequence -> BitSequence
append (Bits one) (Bits two) =
  Bits <| one ++ two
  

-- Util

charValue : Char -> Int
charValue char =
  case char of
    '0' -> 0
    _ -> 1
      
