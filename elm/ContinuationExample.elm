module ContinuationExample exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events as Event
import Cmd.Extra as Cmd

{- Demonstrate delayed calculation inspired by continuation-passing style.
See chapter 22.
-}

-- multi-step calculation

type alias NextStep = Int -> Msg
  
plusC : Int -> Int -> NextStep -> Msg
plusC x y next = 
  RunContinuation next (x + y)

timesC : Int -> Int -> NextStep -> Msg
timesC x y next = 
  RunContinuation next (x * y)

steps : Int -> Int -> Int -> Int -> Msg
steps a b c d =
 let                                             
    step1 =                                            
      plusC a b step2
                                                         
    step2 =                                      
      \result -> timesC c result step3            
                                                 
    step3 =                                      
      \result2 -> plusC result2 d FinalResult
  in                                                     
    step1                 



-- Update

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start a b c d ->
      ( model
      , steps a b c d |> Cmd.perform
      )

    RunContinuation continuation previousResult ->
      ( model
      , continuation previousResult |> Cmd.perform
      )

    FinalResult result ->
      ( { model | value = Just result }
      , Cmd.none
      )


-- Model

type alias Model =
  { value : Maybe Int
  }

init : (Model, Cmd Msg)
init = ( {value = Nothing}
       , Cmd.none
       )

-- Msg  

type Msg
  = Start Int Int Int Int
  | RunContinuation (Int -> Msg) Int
  | FinalResult Int

-- View
      
view : Model -> Html Msg
view {value} =
  div [style [("margin", "4em")]]
    [ p []
        [ text <| toString value ]
    , button [Event.onClick (Start 3 4 5 100)]
             [text "Start"]
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
