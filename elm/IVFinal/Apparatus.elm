module IVFinal.Apparatus exposing (view)

import IVFinal.Types exposing (Model)
import Svg exposing (Svg)
import IVFinal.View.AppSvg as AppSvg exposing ((^^))
import Svg.Attributes exposing (..)
import IVFinal.Apparatus.Constants as C
import IVFinal.Generic.EuclideanTypes exposing (..)

import IVFinal.Apparatus.Droplet as Droplet
import IVFinal.Apparatus.BagFluid as BagFluid

view : Model -> List (Svg msg)
view model = 
  [ -- Hose
    container C.hose
  , fluid C.hose
    
  -- Chamber
  , fluid C.chamberFluid
  , container C.chamber

  -- Bag    
  , BagFluid.view model.bagFluid
  , container C.bag
  , tickMarks

  , Droplet.view model.droplet
  ]

fluid : Rectangle -> Svg msg
fluid coordinates =
  AppSvg.rect coordinates C.fluidAppearance

container : Rectangle -> Svg msg
container coordinates =
  AppSvg.rect coordinates C.containerAppearance

tickMarks : Svg msg    
tickMarks =
  let
    ypos n =
      20 * n
    marking n =
      Svg.line
        [ x1 ^^ 0
        , x2 ^^ 30
        , y1 ^^ ypos n
        , y2 ^^ ypos n
        , stroke "black"
        ] []
  in
    Svg.g [] <| List.map marking (List.range 1 9)
