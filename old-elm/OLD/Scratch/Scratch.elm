module Scratch.Scratch exposing (..)

import Tuple
import Maybe.Extra as Maybe

{-
Note that the name of this module must match the filename
Scratch/Scratch.elm

The following defines a sum type:
-}

type Maybelike a
  = Justlike a
  | Nothinglike

{- 
That produces 1+2 names: the type `Maybelike` (used in declarations) and
the two constructors `Justlike` and `Nothinglike` (used in code).

The typical way to import such a module is this:

> import Scratch.Scratch as Scratch exposing (Maybelike(..))

Now the importing code has to qualify all names with `Scratch`
except for the type name and its constructors. 

When working in the repl, it's often easier just to expose everything:

> import Scratch.Scratch as Scratch exposing (..)

The only issue with that is that the book will often work through
different implementations of the same idea, each in its own module.
Which means you'll later type this to the repl:

> import Scratch.ScratchAlternate as Scratch exposing (..)

That works, but if you now type `map`, Elm will complain that it
doesn't know which one you meant. The easiest thing to do now is 
this:

> :reset
Environment Reset

... which wipes out all imports. (Or you can exit the repl and restart.)

-}

map : (arg -> result) -> Maybelike arg -> Maybelike result
map f maybe =
  case maybe of
    Nothinglike -> Nothinglike
    Justlike arg -> Justlike (f arg)
