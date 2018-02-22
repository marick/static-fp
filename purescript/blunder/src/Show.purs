module Show where

import Prelude

data MyType wrapped = First wrapped | Second

-- Note: `Show` is provided by the prelude.

instance showMyType :: Show wrapped => Show (MyType wrapped) where
  show (First x) = "(First " <> show x <> ")"
  show Second = "Second"
