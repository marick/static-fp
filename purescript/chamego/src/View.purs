module View where

import Prelude hiding (div)

import Events
import State

import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Text.Smolder.HTML (button, div, span)
import Text.Smolder.Markup (text, (#!))

view :: State -> HTML Event
view state =
  div do
    button #! onClick (const Increment) $ text "Increment"
    span $ text (show state.count)
    button #! onClick (const Decrement) $ text "Decrement"
