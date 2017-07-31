module IV.IntField exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event

import Html exposing (..)
import Html.Attributes exposing (..)

-- Model

type alias Model =
  { value : String
  } 

-- Msg  

type Msg
  = ChangeValue String

-- Update

startingModel : Model
startingModel =
  { value = "1"
  }

init : (Model, Cmd Msg)
init = ( startingModel, Cmd.none )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangeValue desired ->
      case String.toInt desired of
        Ok _ -> 
          ( { model | value = desired }
          , Cmd.none
          )
        Err _ ->
          ( model , Cmd.none )

-- View

view : Model -> Html Msg
view model =
  div [style [("margin", "3em")]]
    [ text "Value: "
    , input [ type_ "text"
            , value model.value
            , Event.onInput ChangeValue
            ]
        []
    ]
  
-- Main
      
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }
