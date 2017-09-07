module IVFlat.Generic.TEA exposing
  ( fanOutUpdate
  )

import IVFlat.Generic.Lens as Lens exposing (Lens)

fanOutUpdate :
  (libMsg -> libModel -> (libModel, Cmd appMsg))
  -> libMsg -> appModel
  -> List (Lens appModel libModel)
  -> (appModel, Cmd appMsg)
fanOutUpdate updater subMsg originalModel lenses =
  let
    step lens (changingModel, cmdList) =
      let 
        (newPart, newCmd) =
          updater subMsg (Lens.get lens originalModel)
      in
        ( Lens.set lens newPart changingModel
        , newCmd :: cmdList
        )
  in
    lenses
      |> List.foldl step (originalModel, [])
      |> Tuple.mapSecond (List.reverse >> Cmd.batch)

