module Lens.Try3.Util exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)

import Lens.Try3.Lens as Lens
import Dict
import Array


dict = Dict.singleton      
array = Array.fromList 

-- "update test (with ....)"
updateWith f lens whole expected = 
  equal_ (Lens.update lens f whole) expected

negateVia = updateWith negate

