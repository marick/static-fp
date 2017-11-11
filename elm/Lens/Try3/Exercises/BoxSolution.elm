module Lens.Try3.Exercises.BoxSolution exposing (..)

import Lens.Try3.Lens as Lens
import Lens.Try3.Compose as Compose
import Lens.Try3.Maybe as Maybe
import Lens.Try3.Tuple2 as Tuple2
import Tagged exposing (Tagged(..))


type Box a b
  = Contents a
  | Divided (Contents a) (Contents b)
  | Empty

type Contents a 
  = Creamy a
  | Chunky a
  | Eaten

-- Lenses for exercise 1

contents : Lens.OneCase (Box a b) a
contents =
  let 
    get big =
      case big of
        Contents contents ->
          Just contents
        _ ->
          Nothing
  in
    Lens.oneCase get Contents

creamy : Lens.OneCase (Contents a) a
creamy =
  let 
    get big =
      case big of
        Creamy contents ->
          Just contents
        _ ->
          Nothing
  in
    Lens.oneCase get Creamy

oneCaseAndOneCase : Lens.OneCase a b -> Lens.OneCase b c -> Lens.OneCase a c
oneCaseAndOneCase (Tagged a2b) (Tagged b2c) =
  let
    get =
      a2b.get >> Maybe.andThen b2c.get

    set = 
      b2c.set >> a2b.set
  in
    Lens.oneCase get set
        

-- Lenses for exercise 2

oneCaseToHumble : Lens.OneCase big small -> Lens.Humble big small
oneCaseToHumble (Tagged lens) =
  let
    set_ small big =
      case lens.get big of
        Nothing ->
          big
        Just _ ->
          lens.set small
  in
    Lens.humble lens.get set_

-- Problem 3

      
-- divided : Lens.OneCase (Box a b) (Contents a, Contents b)
divided =
  let 
    get big =
      case big of
        Divided first second ->
          Just (first, second)
        _ ->
          Nothing
    set (first, second) =
      Divided first second
  in
    Lens.oneCase get set


--- Problem 4

oneCaseAndClassic : Lens.OneCase a b -> Lens.Classic b c -> Lens.Humble a c
oneCaseAndClassic a2b b2c =
  Compose.humbleAndHumble
    (oneCaseToHumble a2b)
    (Compose.classicToHumble b2c)


eatFirst : Box a b -> Box a b
eatFirst box = 
  let lens =
    oneCaseAndClassic divided Tuple2.first
  in 
    Lens.set lens Eaten box
