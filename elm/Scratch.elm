module Scratch exposing (..)

-- These are modules used in the book that are not automatically
-- imported.

import Tuple

-- Many of Elm's base types have community supported `<type>.Extra`
-- modules that add useful functions. They're usually imported as
-- follows. After that, you can use functions like `Maybe.values`
-- without having to know which module it comes from.
--
-- `Maybe` itself is automatically imported to all Elm programs.
import Maybe.Extra as Maybe

-- An example function
double : number -> number
double x =
  x + x

{- 
Functions defined here are easy to use in the repl. Here are two ways:

1. A plain import requires that you use the module name to refer to
   module functions.

> import Scratch
> Scratch.double 33
66 : number

2. You can ask for everything in the module to be exposed so the
   module name isn't needed.

> import Scratch exposing (..)
> double 33
66 : number

If you change something in this file, repeat the `import` statement to
make it available. NOTE: if you use the `exposing` form, and you want
the changed functions to stay available without qualification by the
module name, you have to repeat the whole line, including `exposing (..)`. 

-}

-- An example of a multi-line code snippet that would be inconvenient
-- to type in the repl.
snippet =
  Nothing
    |> Maybe.map String.reverse 
    |> Maybe.map (String.append "Dawn")

{- 
You can now see the result of the snippet by importing the module and
typing `snippet` without any arguments.

> import Scratch
> Scratch.snippet
Nothing : Maybe.Maybe String

-}
