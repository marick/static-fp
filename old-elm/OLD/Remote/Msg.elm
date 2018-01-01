module Errors.Remote.Msg exposing (Msg(..))

import Http

type Msg
  = EmphasizeWord String Int
  | LogResponse (Result Http.Error String)
