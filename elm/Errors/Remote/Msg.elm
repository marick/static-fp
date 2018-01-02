module Errors.Remote.Msg exposing (Msg(..))

import Date exposing (Date)
import Http

type Msg
  = Like String Int
  | LastChange Date
  | ChoosePerson String
  | LogResponse (Result Http.Error String)
