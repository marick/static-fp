module Architecture1.Random1 exposing (..)

import Html exposing (..)
import Random
import Tagged exposing (Tagged(..))

type SumTag = SumTag
type alias Model = Tagged SumTag Int

type Msg
  = HandleRandomValue Int

onlyCommand : Cmd Msg    
onlyCommand =
  Random.generate HandleRandomValue (Random.int 0 5)

init : (Model, Cmd Msg)
init = (Tagged 1, onlyCommand)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    HandleRandomValue value ->
      ( Tagged.map ((+) value) model
      , onlyCommand
      )

view : Model -> Html Msg
view model =
  let
    toShow = Tagged.untag model |> toString
  in 
    div [] [ text toShow ]


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
