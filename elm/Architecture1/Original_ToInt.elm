module Architecture1.Original_ToInt exposing (..)

{-                                   WARNING

     When run, this code causes a strobing effect.
     See `========WARNING-READ-THIS========.txt` in this directory 
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Random

-- Model

{-
Note that there's nothing that makes me remove types that are no
longer used. As far as the compiler knows, they're used in some
module that imports this one.
-}

import Tagged exposing (Tagged(..))
type DisplayValueTag = DisplayValueTag_Unused
type alias Model = Int

includeRandomValue : Int -> Model -> Model
includeRandomValue value model =
  value + model

-- Msg  

type Msg
  = HandleRandomValue Int

-- Update
    
init : (Model, Cmd Msg)
init = (0, askForRandomValue)

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
    toShow = model |> toString
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
