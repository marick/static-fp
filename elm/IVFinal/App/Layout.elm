module IVFinal.App.Layout exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA

wrapper : List (Html msg) -> Html msg
wrapper contents = 
  H.div
    [ HA.style [ ("margin", "4em")
               , ("width", "600px")
               ]
    ]
    [ H.div 
        [ HA.style [("display", "flex")]
        ]
        contents
    , H.div []
      boilerplate
    ]
      
canvas : List (Svg msg) -> Html msg
canvas contents =
  H.div []
    [ S.svg 
        [ SA.version "1.1"
        , SA.width "200"
        , SA.height "400"
        ]
        contents
    ]

form : List (Html msg) -> Html msg
form contents = 
  H.div [] contents


boilerplate =
  [ H.p []
      [ H.text
          """
              This example is derived from an app used to teach
              students of veterinary medicine. They calculate the
              appropriate drip rate and time (based on information
              given to them by an instructor), then use the app to see
              if the ending fluid level is what they expected.
          """
      ]
  , H.p []
      [ H.text "Here are some interesting values to try: "
      , H.ul []
        [ H.li [] [H.text "Drip rate of 2 for 5 hours."]
        , H.li [] [H.text "Drip rate of 13 for 5 hours, 30 minutes."]
        , H.li [] [H.text "Drip rate of 5 for 16 hours."]
        ]
      ]
  ]
