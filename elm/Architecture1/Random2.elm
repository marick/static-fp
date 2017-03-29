module Architecture1.Random2 exposing (..)

import Html exposing (..)
import Html.Events as Event
import Random
import Tagged exposing (Tagged(..))

type SumTag = SumTag
type alias Model = Tagged SumTag Int

type Msg
  = HandleRandomValue Int
  | Negate

onlyCommand : Cmd Msg
onlyCommand =
  Random.generate HandleRandomValue (Random.int 0 5)

init : (Model, Cmd Msg)
init = (Tagged 0, onlyCommand)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    HandleRandomValue value ->
      ( Tagged.map ((+) value) model
      , onlyCommand
      )
    Negate ->
      ( Tagged.map negate model
      , onlyCommand
      )

view : Model -> Html Msg
view model =
  let
    toShow = Tagged.untag model |> toString
  in 
    div []
      [ text toShow
      , button [Event.onClick Negate] [text "Negate"]
      ]

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }
