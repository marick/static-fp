module Optics.Prism exposing (..)

type alias Prism whole part =
  { get : whole -> Maybe part
  , set : part -> whole
  }

prism : (whole -> Maybe part) -> (part -> whole) -> Prism whole part
prism getter setter =
  { get = getter, set = setter}
  
get : Prism whole part -> whole -> Maybe part
get prism = prism.get

set : Prism whole part -> part -> whole 
set prism = prism.set


update : Prism whole part -> (part -> part) -> whole -> whole
update prism f whole =
  case prism.get whole of
    Nothing ->
      whole
    Just part ->
      prism.set (f part)

type Identifier
  = Id Int
  | SimpleName String String

one =  prism
         (\whole ->
            case whole of
              Id id -> Just id
              _ -> Nothing)

         (\id ->
            Id id)

either = prism
         (\whole ->
            case whole of
              Ok val -> Just val
              _ -> Nothing)

         (\ok ->
            Ok ok)
