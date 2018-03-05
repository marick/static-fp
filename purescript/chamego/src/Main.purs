module Main where

import Prelude

import Control.Bind (bind)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Unit (Unit)
import DOM (DOM)
import Pux (start, EffModel)
import Pux.Renderer.React (renderToDOM)
import Signal.Channel (CHANNEL)

-- import FormsExample.Form (foldp, view, init)
import State as State
import State (State)
import View as View
import Events

foldp :: forall fx. Event -> State -> EffModel State Event fx
foldp Increment state = { state: state { count = state.count + 1 }, effects: [] }
foldp Decrement state = { state: state { count = state.count - 1 }, effects: [] }



main :: ∀ fx. Eff (channel :: CHANNEL, dom :: DOM, exception :: EXCEPTION | fx) Unit
main = do
  app <- start
    { initialState: State.init
    , view: View.view
    , foldp
    , inputs: []
    }

  renderToDOM "#app" app.markup app.input
