module IVBits.ValidatedString exposing
  ( ValidatedString
  , make
  )

{- A record that stores both a string and, Maybe, the value it parses to.

Clients are responsible for parsing and validation.
-}

type alias ValidatedString a =
  { literal : String
  , value : Maybe a
  }

-- Elm creates a `ValidatedString` constructor, which I'll reimplement
-- because PureScript doesn't do the same.
make : String -> Maybe a -> ValidatedString a
make literal value =
  { literal = literal
  , value = value
  }
