module IVBits.ValidatorsTest exposing (..)

-- I'm using `Validated` because it reads nicely: `Validated.hours`
import IVBits.Validators as Validated

import Test exposing (..)
import Expect

{- This file logically has this structure:

     describe "Validators"
       describe "`hours`"
         describe "valid hours"
         describe "invalid hours"
       describe "`minutes`"
         describe "valid minutes"
         describe "invalid minutes"

   I've chosen to flatten the hierarchy into four separate test suites:

      validHours : Test
      invalidHours : Test
      validMinutes : Test
      invalidMinutes : Test


   Even though I use Emacs, which easily lets me make a big test file
   look like the nested "describe" structure, I find the top levels of
   indentation not helpful. Plus if you *don't* use Emacs, or are too
   lazy to use `set-selective-display`, the way most any syntax
   colorizer will highlight top level variables (`validHours`)
   differently than nested function calls (`describe "valid hours"`)  `
   is more scannable. In my setup, I can scan for green words right next
   to the left margin. It's really easy.
-}

validHours : Test
validHours =
  describe "valid hours"
    [
    ]

invalidHours : Test
invalidHours =
  describe "valid hours"
    [
    ]

validMinutes : Test
validMinutes =
  describe "valid minutes"
    [
    ]

invalidMinutes : Test
invalidMinutes =
  describe "valid minutes"
    [
    ]

