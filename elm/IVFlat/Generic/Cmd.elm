module IVFlat.Generic.Cmd exposing (..)

import Task

msg: msg -> Cmd msg
msg msg =
  Task.perform identity (Task.succeed msg)

wrap: (a -> msg) -> a -> Cmd msg
wrap wrapper value =
  Task.perform wrapper (Task.succeed value)

  
