module View where

import Prelude hiding (div)
import Data.String.Utils as String
import Data.Maybe
import Data.FunctorWithIndex (mapWithIndex)
import Data.Map as Map
import Data.Foldable
import Data.List (List)
import Data.List as List

import Events
import State (State)

import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Text.Smolder.HTML 
import Text.Smolder.Markup (text, (#!), Markup)
import Data.Foldable (class Foldable)

likeSymbol :: String
likeSymbol = "💖 "

chooseSymbol :: String
chooseSymbol = "👍"

errorSymbol :: String
errorSymbol = "❌"               
               




view :: State -> HTML Event
view state =
  div do
    viewSelector state.focusPerson $ Map.keys state.words
    viewStatistics state


viewSelector :: forall ignored. 
                String -> List String -> Markup ignored
viewSelector focusName names =
  p do
    for_ names markup
  where
    markup name =
      text $ name <> " "

      -- case name == focusName of
      --  true -> clickme (ChoosePerson name) name
      --  false -> clickme (ChoosePerson name) name
addSpacing strings =
  List.concatMap withSpace strings
  where
    withSpace s = List.fromFoldable [s, " "]

-- sequence_? `traverse (_ *> text " ")`

-- viewSelected :: State -> HTML Event
-- viewSelected {focusPerson, words} =
    
-- --    mapWithIndex (showOne focusPerson) personWords
-- --      # addBadButtons
--   where
--     personWords =
--       []
-- --      Map.lookup focusPerson words # fromMaybe []

--     showOne person index word =
--       div
--       -- div do
--       --   clickme (Like person index) chooseSymbol
--       --   text $ " " -- <> word.text <> ": " <> showLikes word.count

--     showLikes count =
--       String.repeat count likeSymbol

--     -- addBadButtons list =
--     --   list <> [ button (Like focusPerson 888) (errorSymbol ++ "missing word")
--     --           , button (Like "joe" 0)         (errorSymbol ++ "missing person")
--     --           ]


viewStatistics :: State -> HTML Event
viewStatistics {clickCount, lastChange} =
  div do
    countDisplay
    dateDisplay
  where
    countDisplay = 
      p do
        text $ "You've clicked " <> show clickCount <> pluralize clickCount

    pluralize 1 = " time."
    pluralize _ = " times."

    dateDisplay = 
      p do
        text "Last change: "
        text dateString

    dateString = 
      case lastChange of
        Nothing -> "none"
        Just date -> show date


{- Util -}
    
clickme :: Event -> String -> HTML Event
clickme event label =       
  button #! onClick (const event)
    $ strong (text label)

