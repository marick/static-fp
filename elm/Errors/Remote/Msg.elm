module Errors.Remote.Msg exposing (Msg(..))

import Errors.Remote.Model exposing (Name, Index)
import Date exposing (Date)
import Http

type Msg
  = Like Name Index
  | ChoosePerson Name
  | LastChange Date
  | LogResponse (Result Http.Error String)
