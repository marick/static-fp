module Lens.Try1.LawViolationSolution exposing (..)

import Lens.Try1.Lens as Lens

type Sum a = Sum a a 
  
lens1 =
  let
    get (Sum first _) =
      first
    set newFirst (Sum first second) =
      Sum first newFirst
  in
    Lens.classic get set


lens2 =
  let
    get (Sum first _) =
      first
    set newFirst _ =
      Sum newFirst newFirst
  in
    Lens.classic get set
       
lens3 =
  let
    get (Sum first _) =
      first
    set newFirst (Sum _ count) =
      Sum newFirst (count + 1)
  in
    Lens.classic get set
        
