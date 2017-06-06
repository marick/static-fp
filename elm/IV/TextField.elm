module IV.TextField exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event

import Html exposing (..)
import Html.Attributes exposing (..)
import IV.Common.Html as H

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
  { value = "hi"
  }

init : (Model, Cmd Msg)
init = ( startingModel, Cmd.none )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangeValue desired ->
      ( { model | value = desired ++ desired }
      , Cmd.none
      )

-- View

view : Model -> Html Msg
view model =
  H.wrapper 
    [ div []
        [ text "Value: "
        , input [ type_ "text"
                , value model.value
                , Event.onInput ChangeValue
                ]
            []
        ]
    ]

-- Main
      
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }
