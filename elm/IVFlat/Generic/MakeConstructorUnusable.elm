module IVFlat.Generic.MakeConstructorUnusable exposing
  ( Recursive )

{- Use this when you want to make a value constructor impossible to call.
The typical use is with phantom types:

    -- joneshf/elm-tagged
    import Tagged exposing (Tagged)
    import MakeConstructorUnusable

    type LitersTag = LitersTag MakeConstructorUnusable.Recursive
    type alias Liters = Tagged LitersTag Float

A `LitersTag` value can never be created. To do that, we'd have to create
a `Recursive`. But the value constructor for `Recursive` requires that we
give *it* a `Recursive`. We'd have to create an infinite structure:

    Recursive (Recursive (Recursive (Recursive ...

Therefore, the only way to create a `Liters` is via type annotations:

    liters : Float -> Liters
    liters = Tagged

See the chapter on sum type idioms in https://leanpub.com/outsidefp
-}

type Recursive = Recursive Recursive
