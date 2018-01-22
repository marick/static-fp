module Errors.Exercises.Flow.FlowSolution exposing (..)

type alias ModelState model = Result model model

always_do : (model -> model) -> ModelState model -> ModelState model
always_do f soFar =
  case soFar of
    Ok model -> Ok <| f model
    Err model -> Err <| f model

whenOk_do : (model -> model) -> ModelState model -> ModelState model
whenOk_do = Result.map

whenOk_try : (model -> Maybe model) -> ModelState model -> ModelState model
whenOk_try f soFar = 
  case soFar of
    Ok model ->
      case f model of
        Just newModel -> Ok newModel
        Nothing -> Err model
    e -> e

finishWith : Cmd msg -> ModelState model -> (model, Cmd msg)
finishWith cmd soFar = 
  case soFar of
    Ok model -> (model, cmd)
    Err model -> (model, Cmd.none)
