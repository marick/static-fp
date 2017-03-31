module Structure.GoodSplit.Two exposing (Two(..))

import Structure.GoodSplit.One exposing (One(..))

type Two
  = Link Float (One Two)

