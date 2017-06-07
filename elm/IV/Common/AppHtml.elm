module IV.Common.AppHtml exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

wrapper : List (Html msg) -> Html msg
wrapper content =
  div [style [("margin", "4em")]] content

