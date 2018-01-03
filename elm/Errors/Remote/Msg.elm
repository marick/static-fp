module Errors.Remote.Msg exposing (Msg(..))

import Errors.Remote.Model exposing (Name)
import Date exposing (Date)
import Http

type Msg
  = Like Name Int
  | ChoosePerson Name
  | LastChange Date
  | LogResponse (Result Http.Error String)
