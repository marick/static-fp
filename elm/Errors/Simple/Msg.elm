module Errors.Simple.Msg exposing (Msg(..))

import Errors.Simple.Model exposing (Name)
import Date exposing (Date)

type Msg
  = Like Name Int
  | ChoosePerson Name
  | LastChange Date
