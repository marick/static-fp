module Errors.Remote.View exposing (view)

import Errors.Remote.Msg exposing (Msg(..))
import Errors.Remote.Model exposing (Model)
import Errors.Remote.Word exposing (Word)

import Date.Extra as Date

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import Array
import Dict
import String.Extra as String


likeSymbol : String
likeSymbol = "💖 "

chooseSymbol : String
chooseSymbol = "👍"

errorSymbol : String
errorSymbol = "❌"               
               
view : Model -> Html Msg      
view model =
  div [ style [("margin", "4em")]]
    [ viewSelector model.focusPerson <| Dict.keys model.words
    , viewSelected model
    , viewStatistics model
    ]

viewSelector : String -> List String -> Html Msg
viewSelector focus all =
  let
    one name =
      span []
        [ case name == focus of
            True ->
              strong [style [("font-size", "2em")]] [text focus]
            False ->
              button (ChoosePerson name) name
        , text " "
        ]
              
  in
    p [] (List.map one all ++
            [button (ChoosePerson "joe") errorSymbol])
    
viewSelected : Model -> Html Msg    
viewSelected {focusPerson, words} =
  let
    personWords =
      Dict.get focusPerson words
        |> Maybe.withDefault Array.empty
        |> Array.toList

    showLikes count =
      String.repeat count likeSymbol

    showOne : String -> Int -> Word -> Html Msg
    showOne person index word = 
      div []
        [ button (Like person index) chooseSymbol
        , text <| " " ++ word.text ++ ": " ++ showLikes word.count
        ]

    addBadButton list = -- click on a nonexistent word
      list ++ [button (Like focusPerson 888) errorSymbol]
  in
    div []
      (personWords
        |> List.indexedMap (showOne focusPerson)
        |> addBadButton
      )

viewStatistics : Model -> Html Msg      
viewStatistics {clickCount, lastChange} =
  let
    countDisplay = 
      p []
        [ text <|
            "You've clicked " ++ 
            (String.pluralize "time" "times" clickCount) ++
            "."
        ]

    dateDisplay = 
      p []
        [ text "Last change: "
        , text dateString
        ]

    dateString = 
      case lastChange of
        Nothing -> "none"
        Just date -> Date.toIsoString date
  in
    div []
      [ countDisplay
      , dateDisplay
      ]

{- Util -}
    
button : Msg -> String -> Html Msg
button onClick label =       
  Html.button
    [ Event.onClick onClick ]
    [strong [] [text label]]
      
