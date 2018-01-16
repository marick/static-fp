module TypeClass.DecodeTest exposing (..)
import Test exposing (..)
import Expect
import Fuzz exposing (Fuzzer)
import TestBuilders exposing (..)

import Json.Decode as Decode exposing (Decoder)

{- A test constructor that takes two decoders that are supposed to be
   equivalent. The fuzzer argument produces N appropriate JSON strings.
   Each is fed to both fuzzers, and the resulting values are compared.
   If all samples are equal, we get some confidence that the decoders
   will produce the same result for all JSON strings.
-}

decoderEquality : Fuzzer String -> Decoder a -> Decoder a -> String -> Test
decoderEquality fuzzer left right comment =
  let
    results json =
      ( Decode.decodeString left  json
      , Decode.decodeString right json
      )
    runOne json =
      results json |> uncurry Expect.equal
  in
    fuzz fuzzer comment runOne

{- Construct JSON strings that contains a good proportion of valid ints. 
   (`Fuzz.string` itself might produce none.)
-}
intString : Fuzzer String
intString =
  Fuzz.frequency
    [ (1 , Fuzz.map toString Fuzz.int)
    , (1 , Fuzz.string)
    ]

{- The two functor laws. -}
    
identityLaw : Test
identityLaw =
  let
    left = Decode.string 
    right = Decode.map identity left
  in
    decoderEquality Fuzz.string left right       "identity"

compositionLaw : Test
compositionLaw = 
  let
    f = (*) 5
    g = (+) 1
        
    left =  Decode.int |> Decode.map (f >>            g) 
    right = Decode.int |> Decode.map  f |> Decode.map g  
  in
    decoderEquality intString left right        "composition"


