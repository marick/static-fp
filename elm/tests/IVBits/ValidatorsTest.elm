module IVBits.ValidatorsTest exposing (..)

-- I'm using `Validated` because it reads nicely: `Validated.hours`
import IVBits.Validators as Validated

import Test exposing (..)
import Expect exposing (Expectation)
import TestUtil exposing (..)
import Random exposing (maxInt)



x = 3
