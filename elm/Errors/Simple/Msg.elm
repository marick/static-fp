module Errors.Simple.Msg exposing (Msg(..))

import Errors.Simple.Model exposing (Name, Index)
import Date exposing (Date)

type Msg
  = Like Name Index
  | ChoosePerson Name
  | LastChange Date
