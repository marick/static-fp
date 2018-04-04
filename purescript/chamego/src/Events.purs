module Events where

import State (Name, Index)
import Data.DateTime.Locale (LocalDateTime)

data Event
  = Like Name Index
  | ChoosePerson Name
  | LastChange LocalDateTime


