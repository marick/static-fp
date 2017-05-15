module Architecture1.Original exposing (..)

{-                                   WARNING

     When run, this code causes a strobing effect.
     See `========WARNING-READ-THIS========.txt` in this directory 
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Random
import Tagged exposing (Tagged(..))

-- Model

type DisplayValueTag = DisplayValueTag_Unused
type alias Model = Tagged DisplayValueTag Int

includeRandomValue : Int -> Model -> Model
includeRandomValue value model =
  Tagged.map ((+) value) model

-- Msg  

type Msg
  = HandleRandomValue Int

-- Update
    
init : (Model, Cmd Msg)
init = (Tagged 0, askForRandomValue)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    HandleRandomValue value ->
      ( includeRandomValue value model
      , askForRandomValue
      )

askForRandomValue : Cmd Msg
askForRandomValue =
  Random.generate HandleRandomValue (Random.int 0 5)

-- View
      
view : Model -> Html Msg
view model =
  let
    toShow = Tagged.untag model |> toString
  in 
    div [] [ text toShow ]

-- Main
      
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }
