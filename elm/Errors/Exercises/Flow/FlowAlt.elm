module Errors.Exercises.Flow.FlowAlt exposing (..)

type alias ModelState model = 
  { ok : Bool
  , model : model
  }
    
always_do : (model -> model) -> ModelState model -> ModelState model
always_do f soFar =
  soFar

whenOk_do : (model -> model) -> ModelState model -> ModelState model
whenOk_do f soFar =
  soFar
    
whenOk_try : (model -> Maybe model) -> ModelState model -> ModelState model
whenOk_try f soFar = 
  soFar
    
finishWith : Cmd msg -> ModelState model -> (model, Cmd msg)
finishWith cmd soFar = 
  (soFar.model , Cmd.none)
