module Records.BasicSolution exposing (..)

-- Problem 1

maker : String -> { name : String, id : Int }
maker name =
  { name = name, id = 3 }

taker : { id : Int } -> Int
taker record =
  record.id
        
takerVariant : { whole | id : Int } -> Int
takerVariant record =
  record.id

{-
   `makerVariant` is impossible. The executable code creates a
   record with a `name` field, but `taker` allows only records
   with exactly one field: `id`. 
-}

-- Problem 2

{-
   The unannotated `setName` had this type:

      <function> : a -> { c | name : b } -> { c | name : a }

   I didn't know that the { record | ... } notation could change not
   only a field's value but also its *type*. Weird. 
-}

setName : part -> { whole | name : part } -> { whole | name : part }
setName newValue record =
  { record | name = newValue } 

-- Problem 3

type alias Lens3 whole part =
  { get : { whole | name : part } -> part
  , set : part -> { whole | name : part } -> { whole | name : part }
  }

lens3 : Lens3 whole part
lens3 = { get = .name, set = setName }

-- Problem 4

type alias Lens4 whole part =
  { get : whole -> part
  , set : part -> whole -> whole
  }

lens4 : (whole -> part) -> (part -> whole -> whole) -> Lens4 whole part
lens4 getter setter =
  { get = getter, set = setter }

-- Problem 5

type alias Point = { x : Float, y : Float }

myPoint = { x = 1.1, y = 3.3 }
    
type alias Lens whole part =
  { get : whole -> part
  , set : part -> whole -> whole
  , update : (part -> part) -> whole -> whole
  }

  
lens : (whole -> part) -> (part -> whole -> whole) -> Lens whole part
lens getter setter =
  let
    updater f whole =
      setter (f (getter whole)) whole
  in
    { get = getter, set = setter, update = updater }
  
pointX = lens .x (\newX whole -> { whole | x = newX })
          
