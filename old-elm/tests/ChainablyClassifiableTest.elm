module ToInt.ChainablyClassifiableTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import ToInt.ChainablyClassifiable as C

type Classification a = A a | B a | C a | D a 

elseMustBe : Test
elseMustBe =
  describe "elseMustBe"
    [ test "retains classified result" <| \_ ->
        C.unclassified 1
        |> C.mightBe (always True) A
        |> C.elseMustBe B
        |> Expect.equal (A 1)
    , test "adds classification to unclassified result" <| \_ ->
        C.unclassified 1
        |> C.mightBe (always False) A
        |> C.elseMustBe B
        |> Expect.equal (B 1)
    ]

mightBe : Test
mightBe =
  describe "mightBe"
    [ test "passes on a known value" <| \_ ->
        C.unclassified 1
        |> C.mightBe ((==) 1) A
        |> C.mightBe ((==) 1) B -- this will be skipped
        |> C.elseMustBe C
        |> Expect.equal (A 1)
    ]

rework : Test
rework =
  describe "rework"
    [ test "changes the working value" <| \_ ->
        C.unclassified 1
        |> C.rework ((+) 3)
        |> C.mightBe ((==) 1) A   -- nope
        |> C.mightBe ((==) 4) B   -- yup
        |> C.elseMustBe C
        |> Expect.equal (B 1) -- note that the working value is discarded
    ]


reworkMaybe : Test
reworkMaybe =
  describe "reworkMaybe"
    [ test "can change the working value" <| \_ ->
        C.unclassified 1
        |> C.reworkMaybe (always (Just 4)) D -- D will be ignored
        |> C.mightBe ((==) 1) A   -- nope
        |> C.mightBe ((==) 4) B   -- yup
        |> C.elseMustBe C
        |> Expect.equal (B 1)
    , test "can act to classify in case of Nothing" <| \_ ->
        C.unclassified 1
        |> C.reworkMaybe (always Nothing) D -- D will be applied
        |> C.mightBe ((==) 1) A   -- nope
        |> C.elseMustBe C
        |> Expect.equal (D 1)
    ]


reworkResult : Test
reworkResult =
  describe "reworkResult"
    [ test "can change the working value" <| \_ ->
        C.unclassified 1
        |> C.reworkResult (always (Ok 4)) D -- D will be ignored
        |> C.mightBe ((==) 1) A   -- nope
        |> C.mightBe ((==) 4) B   -- yup
        |> C.elseMustBe C
        |> Expect.equal (B 1)
    , test "can act to classify in case of Err" <| \_ ->
        C.unclassified 1
        |> C.reworkResult (always (Err "foo")) D -- D will be applied
        |> C.mightBe ((==) 1) A   -- nope
        |> C.elseMustBe C
        |> Expect.equal (D 1)
    ]


