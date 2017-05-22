module SumTypes.PhantomTaggingUse exposing (..)

{-
  Copy the uses below into your solution file, omitting
  the type just below. It's just there so that the file compiles
  without error.
-}

type Tagged tag value = Tagged value


----- Uses  

type DripRate = DripRate_Unused
type Percent = Percent_Unused
type Minutes = Minutes_Unused

dripRate : Float -> Tagged DripRate Float
dripRate = Tagged 

percent : Float -> Tagged Percent Float
percent  = Tagged 
             
minutes : Float -> Tagged Minutes Float
minutes = Tagged


minutesUntilCheck : Tagged DripRate Float -> Tagged Minutes Float
minutesUntilCheck (Tagged rate) =
  let
    calculation perSecond = (2000 * 15) / (60 * perSecond)
  in
    rate |> calculation |> minutes
