-- This is the first example of a module in a subdirectory. The module name
-- requires that the file live in `<root>/Maybe/One.elm`.

module Maybe.One exposing (..)

{-
                        * Importing a module * 

You can import this module in three ways. The first two you've
probably already seen in `Scratch.elm`. The last one is new.

`import Maybe.One`
   You have to refer to functions with a fully qualified name like
   `Maybe.One.toBool`

`import Maybe.One exposing (..)`

   You can refer to functions without any qualification: `toBool`.

`import Maybe.One as One`
   This is a common convention for multi-component module names.
   You can now use names like `One.toBool`
-}

{-
The module named `Maybe` is automatically imported to all Elm
programs, as are the two names `Just` and `Nothing`. Other names
are qualified with the module name, like `Maybe.map`. 

However, many of Elm's base types have community supported
`<type>.Extra` modules that add useful functions. They're usually
imported as follows. After that, you can use functions like
`Maybe.values` without having to know which module it comes from.
-}

import Maybe.Extra as Maybe


toBool maybe =
  False

join maybe =
  Nothing

toList maybe =
  []
