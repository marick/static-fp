module SumTypes.Random exposing (..)

import Html exposing (..)
import Random

type Msg = HandleRandomValue Int

onlyCommand =
  Random.generate HandleRandomValue (Random.int 0 5)

init : (Int, Cmd Msg)
init = (1, onlyCommand)

update msg model =
  case msg of
    HandleRandomValue value ->
      (model + value, onlyCommand)

view model = 
  div [] [ text (toString model) ]


-- The following tells the runtime where to find the
-- functions it calls. `subscriptions` are used to 
-- get messages provoked by things other than commands
-- or user interactions with the browser. Examples
-- include clock ticks and data coming over a web socket. 
    
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }
