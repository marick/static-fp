module Errors.Simple.Exercises.FlowAltSolution exposing (..)

type alias ModelState model = 
  { ok : Bool
  , model : model
  }
    
always_do : (model -> model) -> ModelState model -> ModelState model
always_do f soFar =
  { soFar | model = f soFar.model }

whenOk_do : (model -> model) -> ModelState model -> ModelState model
whenOk_do f soFar =
  case soFar.ok of
    True -> always_do f soFar
    False -> soFar

whenOk_try : (model -> Maybe model) -> ModelState model -> ModelState model
whenOk_try f soFar = 
  case soFar.ok of
    True ->
      case f soFar.model of
        Just newModel -> { ok = True,  model = newModel }
        Nothing ->       { ok = False, model = soFar.model }
    False -> soFar

finishWith : Cmd msg -> ModelState model -> (model, Cmd msg)
finishWith cmd soFar = 
  case soFar.ok of
    True ->  (soFar.model, cmd)
    False -> (soFar.model, Cmd.none)
