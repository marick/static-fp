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

import State as State
import State (State, Name, Index)
import View as View
import Events (Event(..))

foldp :: forall fx. Event -> State -> EffModel State Event fx
foldp (Like name index) state
  = { state : state, effects : [] }

foldp (ChoosePerson name) state
  = { state : state, effects : [] }

foldp (LastChange time) state
  = { state : state, effects : [] }



main :: ∀ fx. Eff (channel :: CHANNEL, dom :: DOM, exception :: EXCEPTION | fx) Unit
main = do
  app <- start
    { initialState: State.init
    , view: View.view
    , foldp
    , inputs: []
    }

  renderToDOM "#app" app.markup app.input
