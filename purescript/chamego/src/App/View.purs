module App.View
  ( view
  ) where

import Prelude hiding (div)

import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Text.Smolder.HTML (div, button)
import Text.Smolder.Markup (text, (#!), (!))

-- LOCAL
import App.Update (State)
import App.Events (Event(..))
import App.Styles (styledButton)

view :: State -> HTML Event
view { currentColor } =
  div do
    div ! styledButton "red" currentColor    #! onClick (const $ UserClick "red")    $ text ""
    div ! styledButton "green" currentColor  #! onClick (const $ UserClick "green")  $ text ""
    div ! styledButton "blue" currentColor   #! onClick (const $ UserClick "blue")   $ text ""
    div ! styledButton "yellow" currentColor #! onClick (const $ UserClick "yellow") $ text ""
    button #! onClick (const StartGame ) $ text "Start"

