module Lens.Final.Util exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)

import Lens.Final.Lens as Lens
import Dict
import Array


dict = Dict.singleton      
array = Array.fromList 

-- "update test (with ....)"
updateWith f lens whole expected = 
  equal_ (Lens.update lens f whole) expected

negateVia = updateWith negate

