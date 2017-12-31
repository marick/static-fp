module Errors.Simple.Msg exposing (Msg(..))

import Date exposing (Date)

type Msg
  = Like String Int
  | LikeDate Date
