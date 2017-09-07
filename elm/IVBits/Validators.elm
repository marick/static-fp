module IVBits.Validators exposing
  ( ValidatedString
  , hours
  , minutes
  )

type alias ValidatedString a =
  { literal : String
  , value : Maybe a
  }

-- Elm creates a `ValidatedString` constructor, which I'll reimplement
-- because PureScript doesn't do the same.
validated : String -> Maybe a -> ValidatedString a
validated literal value =
  { literal = literal
  , value = value
  }

-- Exported functions

hours : String -> ValidatedString Int
hours candidate =
  validated "" Nothing
      
minutes : String -> ValidatedString Int
minutes candidate = 
  validated "" Nothing

