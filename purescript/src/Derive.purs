module App.State where

import Data.Newtype (class Newtype)

newtype State = State
  { title :: String
  , loaded :: Boolean
  }

derive instance newtypeState :: Newtype State _

