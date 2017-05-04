module Maybe.One exposing (..)

-- The name of this module signifies that the file lives in
-- `<root>/Maybe/One.elm`. You can import the file in three ways:
--
-- `import Maybe.One`
--    You have to refer to functions with a fully qualified name like
--    `Maybe.One.toBool`
--
-- `import Maybe.One exposing (..)`
--
--    You can refer to functions without any qualification: `toBool`.
--
-- `import Maybe.One as One`
--    This is a common convention for multi-component module names.
--    You can now use names like `One.toBool`

toBool maybe = False

join maybe = Nothing

toList maybe = []
