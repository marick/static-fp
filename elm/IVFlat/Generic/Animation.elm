module IVFlat.Generic.Animation exposing
  ( updateAnimations
  , updateAnimations2
  )

import Animation
import Animation.Messenger
import IVFlat.Generic.Lens as Lens exposing (Lens)
import IVFlat.Generic.TEA as TEA

updateAnimations : Animation.Msg -> appModel
                 -> List (Lens appModel (Animation.Messenger.State appMsg))
                 -> (appModel, Cmd appMsg)
updateAnimations subMsg originalModel lenses =
  let
    step lens (changingModel, cmdList) =
      let 
        (newPart, newCmd) =
          Animation.Messenger.update subMsg (Lens.get lens originalModel)
      in
        ( Lens.set lens newPart changingModel
        , newCmd :: cmdList
        )
  in
    lenses
      |> List.foldl step (originalModel, [])
      |> Tuple.mapSecond (List.reverse >> Cmd.batch)


updateAnimations2 :
  Animation.Msg
  -> model
  -> List (Lens model (Animation.Messenger.State msg))
  -> (model, Cmd msg)
updateAnimations2 =
  TEA.fanOutUpdate Animation.Messenger.update
