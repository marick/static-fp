module Lens.Final.TEA.UpdateComposite exposing (..)

import Lens.Final.Lens as Lens
import Lens.Final.Compose.Operators exposing (..)
import Array exposing (Array)


type alias Whole err msg model = 
  { current : Result err model
  , originalModel : model
  , msg : msg
  , cmds : Array (Cmd msg)
  }

originalModel : Lens.Classic (Whole err msg model) model
originalModel =
  Lens.classic .originalModel (\originalModel whole -> { whole | originalModel = originalModel })

msg : Lens.Classic (Whole err msg model) msg
msg =
  Lens.classic .msg (\msg whole -> { whole | msg = msg })

cmds : Lens.Classic (Whole err msg model) (Array (Cmd msg))
cmds =
  Lens.classic .cmds (\cmds whole -> { whole | cmds = cmds })

current : Lens.Classic (Whole err msg model) (Result err model)
current =
  Lens.classic .current (\current whole -> { whole | current = current })

    
pack : model -> msg -> Whole err msg model
pack model msg =
  { originalModel = model
  , msg = msg
  , cmds = Array.empty
  , current = Ok model
  }

unpack : (Whole err msg model -> err -> Cmd msg) -> Whole err msg model -> (model, Cmd msg)
unpack errCmdMaker whole =
  case whole.current of
    Ok model ->
      ( model, Cmd.batch <| Array.toList whole.cmds)
    Err err ->
      ( whole.originalModel , errCmdMaker whole err )


liftWithConverter_ : (model -> fnOut -> Result err model)
                   -> (model -> fnOut)
                   -> Whole err msg model
                   -> Whole err msg model
liftWithConverter_ converter f whole =
  case whole.current of
    Ok model ->
      Lens.set current (f model |> converter model) whole 
    Err _ ->
      whole

liftWithConverter : (fnOut -> Result err model)
                  -> (model -> fnOut)
                  -> Whole err msg model
                  -> Whole err msg model
liftWithConverter converter =
  liftWithConverter_ (\_ fnOut -> converter fnOut)


map : (model -> model)
    -> Whole err msg model
    -> Whole err msg model
map = liftWithConverter Ok
    
liftResult : (model -> Result err model)
           -> Whole err msg model
           -> Whole err msg model
liftResult = liftWithConverter identity

