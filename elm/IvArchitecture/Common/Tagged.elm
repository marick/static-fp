module IvArchitecture.Common.Tagged exposing (..)

import Tagged exposing (Tagged(..))

{-| Use to make an instructor that can never be used because
    it's infinitely recursive

    type Tag = Tag UnusableConstructor

 -}
type UnusableConstructor = UnusableConstructor UnusableConstructor

toString : Tagged tag value -> String           
toString tagged = 
  tagged |> Tagged.untag |> Basics.toString

  
