module Errors.Simple.Model exposing (..)

import Errors.Simple.Word as Word exposing (Word)

import Lens.Final.Lens as Lens 
import Lens.Final.Operators exposing (..)
import Date exposing (Date)
import Dict exposing (Dict)
import Array exposing (Array)
import Lens.Final.Dict as Dict
import Lens.Final.Array as Array


{- Model -}

type alias Name = String

type alias Model =
  { words : Dict Name (Array Word)
  , focusPerson : Name
  , clickCount : Int
  , lastChange : Maybe Date 
  }
  
init : (Model, Cmd msg)
init =
  ( { words = startingWords
    , focusPerson = "Dawn"
    , clickCount = 0 
    , lastChange = Nothing
    }
  , Cmd.none
  )


{- Util -}

vocabulary : List String  
vocabulary = ["cafuné", "chamego", "amor da minha vida", "tedioso", "tolerante"]

startingWords : Dict String (Array Word)
startingWords =
  let
    words wordlist =
      wordlist |> List.map Word.new |> Array.fromList
  in
    Dict.fromList
      [ ( "Dawn" , words ["cafuné", "chamego", "amor da minha vida", "tolerante"] )
      , ( "Brian" , words ["amor da minha vida", "tedioso"] )
      ]

{- Lenses -}

-- the basics

words : Lens.Classic Model (Dict String (Array Word))
words =
  Lens.classic .words (\words model -> { model | words = words })


focusPerson : Lens.Classic Model Name
focusPerson =
  Lens.classic .focusPerson (\focusPerson model -> { model | focusPerson = focusPerson })
    
lastChange : Lens.Classic Model (Maybe Date)
lastChange =
  Lens.classic .lastChange (\lastChange model -> { model | lastChange = lastChange })


clickCount : Lens.Classic Model Int
clickCount =
  Lens.classic .clickCount (\clickCount model -> { model | clickCount = clickCount })

-- Composed

personWords : Name -> Lens.Humble Model (Array Word)
personWords who = 
  words .?>> Dict.humbleLens who

word : Name -> Int -> Lens.Humble Model Word
word who index =
  personWords who ??>> Array.lens index

wordCount : Name -> Int -> Lens.Humble Model Int
wordCount who index =
  word who index ?.>> Word.count
