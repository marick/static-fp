module IVFinal.ApparatusView exposing
  ( view
  )

{- The animated apparatus. Code here draws the static part (the containers).
Each changing SVG shape has its own module with its own `view`, called from
here.
-}

import IVFinal.Apparatus.Constants as C
import IVFinal.Apparatus.Droplet as Droplet
import IVFinal.Apparatus.BagFluid as BagFluid
import IVFinal.Apparatus.ChamberFluid as ChamberFluid
import IVFinal.Apparatus.HoseFluid as HoseFluid

import IVFinal.Generic.EuclideanRectangle exposing (Rectangle)
import IVFinal.Types exposing (Model)
import IVFinal.App.Svg as AppSvg exposing ((^^))

import Svg exposing (Svg)
import Svg.Attributes exposing (..)


view : Model -> List (Svg msg)
view model = 
  [ -- Hose
    container C.hoseFluid
  , HoseFluid.view model.hoseFluid
    
  -- Chamber
  , ChamberFluid.view model.chamberFluid
  , container C.chamber

  -- Bag    
  , BagFluid.view model.bagFluid
  , container C.bag
  , tickMarks

  , Droplet.view model.droplet
  ]



  
container : Rectangle -> Svg msg
container coordinates =
  AppSvg.rect coordinates
    [ fill "none"
    , stroke "black"
    ]

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
