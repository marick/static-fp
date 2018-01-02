module Errors.Remote.State exposing (..)

import Lens.Final.Lens as Lens
import Errors.Remote.Model exposing (Model)
import Errors.Remote.Msg exposing (Msg)
import Array exposing (Array)

type alias State err = 
  { model : Model
  , originalForReference : Model
  , msg : Msg
  , cmds : Array (Cmd Msg)

  , err : Maybe err
  }

{- Lenses -}

model : Lens.Classic (State err) Model
model =
  Lens.classic .model (\model clump -> { clump | model = model })

cmds : Lens.Classic (State err) (Array (Cmd Msg))
cmds =
  Lens.classic .cmds (\cmds clump -> { clump | cmds = cmds })

        
err : Lens.Classic (State err) (Maybe err)
err =
  Lens.classic .err (\err clump -> { clump | err = err })

        
