module State where

import Prelude
import Data.Map
import Data.Tuple
import Word as Word
import Word (Word)
import Data.DateTime.Locale (LocalDateTime)
import Data.Maybe
import Data.Lens
import Data.Lens.At (at)
import Data.Lens.Index (ix)


  
{- Model -}

type Name = String
type Index = Int

type State =
  { words :: Map Name (Array Word)
  , focusPerson :: Name
  , clickCount :: Int
  , lastChange :: Maybe LocalDateTime
  }

init :: State
init =
  { words : startingWords
  , focusPerson : "Dawn"
  , clickCount : 0
  , lastChange : Nothing
  }

{- Util -}

vocabulary :: Array String  
vocabulary = ["cafuné", "chamego", "amor da minha vida", "tedioso", "tolerante"]

startingWords :: Map String (Array Word)
startingWords =
  fromFoldable
    [ Tuple "Dawn" $ asWords ["cafuné", "chamego", "amor da minha vida", "tolerante"]
    , Tuple "Brian" $ asWords $ ["amor da minha vida", "tedioso"]
    ]
  where
    asWords = map Word.new


{- Lenses -}

-- the basics

words :: Lens' State (Map String (Array Word))
words =
  lens _.words $ _ { words = _ }


focusPerson :: Lens' State Name
focusPerson =
  lens _.focusPerson $ _ { focusPerson = _ }
    
lastChange :: Lens' State (Maybe LocalDateTime)
lastChange =
  lens _.lastChange $ _ { lastChange = _ }


clickCount :: Lens' State Int
clickCount =
  lens _.clickCount $ _ { clickCount = _ }

-- -- Composed

personWords :: Name ->  Traversal' State (Array Word)
personWords who = 
  words <<< ix who

word :: Name -> Index -> Traversal' State Word
word who index =
  personWords who <<< ix index

wordCount :: Name -> Index -> Traversal' State Int
wordCount who index =
   word who index <<< Word.count
