module App.Events
  ( Event(..)
  ) where

import Data.List (List)

data Event
  = UserClick String
  | ResetColor
  | StartGame
  | NextSequence (List String)
  | AnimateColor String
  | PlaySequence
