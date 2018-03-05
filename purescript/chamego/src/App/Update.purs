module App.Update
  ( State
  , AppEffects
  , foldp
  , init
  ) where

import Prelude

import App.Events (Event(..))
import App.Helpers (generateRandoSequence)
import Color (toHexString)
import Control.Monad.Aff (Aff, delay)
import Control.Monad.Aff.Console (log, logShow)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Random (RANDOM)
import Data.Array (range, concatMap)
import Data.Int (toNumber)
import Data.List (List(..), index, snoc, slice, length)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Time.Duration (Milliseconds(..))
import Pux (EffModel, noEffects, onlyEffects)

type State =
  { currentColor :: String
  , sequence :: List String
  , count :: Int
  , userClicks :: List String
  }

init :: State
init =
  { currentColor: ""
  , sequence: Nil
  , count: 0
  , userClicks: Nil
  }

type AppEffects = (console :: CONSOLE, random :: RANDOM)

generatePlaySequence :: forall e. Int -> List String -> Array (Aff e (Maybe Event))
generatePlaySequence count sequence =
  range 0 (count - 1) #
  concatMap (\v ->
    [ do
        delay $ Milliseconds ((toNumber v + 1.0) * 1000.0)
        let color = fromMaybe "" $ index sequence v
        pure $ Just $ AnimateColor color
    ]
  )

foldp :: Event -> State -> EffModel State Event AppEffects
foldp (UserClick color) state =
  let
    nextUserClicks = snoc state.userClicks color
    allMatch = nextUserClicks == (slice 0 (length nextUserClicks) state.sequence)
  in
    if allMatch && (length nextUserClicks) == state.count then
      { state: state { count = state.count + 1, userClicks = Nil }
      , effects:
        [ pure $ Just $ AnimateColor color
        , pure $ Just PlaySequence
        ]
      }
    else if allMatch then
      { state: state { userClicks = nextUserClicks }
      , effects: [ pure $ Just $ AnimateColor color ]
      }
    else
      { state: state
      , effects:
        [ pure $ Just $ AnimateColor color
        , pure $ Just PlaySequence
        ]
      }


foldp StartGame state = onlyEffects state
  [ do
      colors <- liftEff generateRandoSequence
      pure $ Just $ NextSequence colors
  ]

foldp (NextSequence colors ) state =
  { state: state { sequence = colors, count = state.count + 1 }
  , effects: [ pure $ Just PlaySequence ]
  }

foldp PlaySequence state = onlyEffects state (generatePlaySequence state.count state.sequence)

foldp (AnimateColor color) state =
  { state: state { currentColor = color }
  , effects: [ delay (Milliseconds 300.0) $> Just ResetColor ]
  }

foldp ResetColor state = noEffects state { currentColor = "" }
