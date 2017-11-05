module Scratch exposing (..)

-- Elm automatically imports modules like `List` and `String`.
-- Others need to be specifically imported. Here's an example:
import Tuple

-- An example function
length2 list1 list2 =
  List.length list1 + List.length list2

{- 
Functions defined here are easy to use in the repl. Here are two ways:

1. A plain import requires that you use the module name to refer to
   module functions.

> import Scratch
> Scratch.length2 [1, 2] ["3", "4"]
4 : Int

2. You can ask for everything in the module to be exposed so the
   module name isn't needed.

> import Scratch exposing (..)
> length2 [1, 2] ["3", "4"]
4 : Int

Once you've successfully(*) imported a module, the Elm repl will
automatically reload it whenever you change it. So if you've typed
an expression that didn't work and then change the module, simply redo the
expression to try the new version.

(*) If you get errors while importing the module, Elm won't automatically
retry when the module changes. You need to manually redo the import.

-}
