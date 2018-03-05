module App.Styles
  ( styledButton
  ) where

import Prelude

import CSS (Color, backgroundColor, height, width)
import CSS.Color (red, green, yellow, blue, black, desaturate)
import CSS.Size (px)
import Pux.DOM.HTML.Attributes (style)
import Text.Smolder.Markup (Attribute)

styledButton :: String -> String -> Attribute
styledButton color currentColor =
  let
    converted = convertColor color
    bgColor =
      if currentColor == color then desaturate 0.5 converted
      else converted
  in
   style do
      backgroundColor bgColor
      height $ px 200.0
      width $ px 200.0

convertColor :: String -> Color
convertColor color =
  case color of
    "red" -> red
    "green" -> green
    "yellow" -> yellow
    "blue" -> blue
    _ -> black
