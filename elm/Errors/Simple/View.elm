module Errors.Simple.View exposing (view)

import Errors.Simple.Msg exposing (Msg(..))
import Errors.Simple.Model exposing (Model)
import Errors.Simple.Word exposing (Word)

import Date exposing (Date)
import Date.Extra as Date

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import Array
import Dict
import String.Extra as String

wrapper : List (Html Msg) -> Html Msg
wrapper contents = 
  div
    [ style [("margin", "4em")]]
    contents
      
button : Msg -> String -> Html Msg
button onClick label =       
  Html.button
    [ Event.onClick onClick ]
    [strong [] [text label]]

view : Model -> Html Msg      
view model =
  wrapper
    [ belovedDisplay model
    , buttons
    , clickCountDisplay model.clickCount
    , dateDisplay model.lastChange
    ]

belovedDisplay : Model -> Html Msg    
belovedDisplay model =
  let
    words =
      Dict.get model.focusPerson model.words
        |> Maybe.withDefault Array.empty
        |> Array.toList
  in
    div []
      [ p [] [strong [] [text model.focusPerson]]
      , ul [] <| List.map oneWord words
      ]

clickCountDisplay : Int -> Html Msg      
clickCountDisplay count =
  p []
    [ text <|
        "You've clicked " ++
        (String.pluralize "time" "times" count) ++
        "."
    ]
          
dateDisplay : Maybe Date -> Html Msg
dateDisplay maybe = 
  let
    display = 
      case maybe of
        Nothing -> "none"
        Just date -> Date.toIsoString date
  in
    p []
      [ text "Last change: "
      , text display
      ]
      
oneWord : Word -> Html Msg
oneWord word = 
  let 
    emphasis = String.repeat word.count ("💖" ++ " ")
  in
    li []
      [ text <| word.text ++ ": " ++ emphasis ]

buttons : Html Msg
buttons =
  div []
    [ p [] [button (Like "Dawn"  1)   "Emphasize 'Chamego'"]
    , p [] [button (Like "Dawn"  100) "Try to emphasize the 100th word"]
    , p [] [button (Like "Brian" 1)   "Pick a nonexistent person"]
    ]
