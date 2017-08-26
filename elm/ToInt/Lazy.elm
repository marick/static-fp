module ToInt.Lazy exposing (..)

-- A function that doesn't have laziness available
withIndices : List a -> List (Int, a)
withIndices list =
  let
    counts = List.range 0 (List.length list)
  in
    List.map2 (,) counts list

       

-- Don't call this!
forever : (a -> a) -> a -> List a
forever f seed =
  seed :: forever f (f seed)


-- We're pretending this is a lazy infinite list.
integers : List number
integers = [0, 1, 2, 3, 4, 5]      

withIndicesLazily : List a -> List (Int, a)
withIndicesLazily list =
  List.map2 (,) integers list
      
subtractAllLazy : number -> List number -> number
subtractAllLazy startingValue subtrahends =
  List.foldl (flip (-)) startingValue subtrahends
