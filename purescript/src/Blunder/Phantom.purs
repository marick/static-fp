module Blunder.Phantom where

import Prelude

data Tagged tag value = Tagged value

data PercentTag

type Percent = Tagged PercentTag Number  

percent :: Number -> Percent
percent = Tagged

unwrap :: Percent -> Number
unwrap (Tagged n) = n 

double :: Percent -> Percent
double (Tagged n) = Tagged (n * 2.0)
