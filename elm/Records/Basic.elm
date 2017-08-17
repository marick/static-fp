module Records.Basic exposing (..)

bossie =
  { id = 13837   
  , name = "bossie" 
  , tags = ["heifer"]
  }

setName newName record =
  { record | name = newName }

bossiePlus = { id = 0, name = "", tags = "", bool = True }

hi : { record | name : String } -> String
hi record =
  "Hi " ++ record.name 

type alias Animal =
  { id : Int
  , name : String
  , tags : List String
  }


bossie_second : Animal  
bossie_second =
  { id = 13837
  , name = "bossie"
  , tags = ["heifer"]
  }
  
shorthand : Animal -> String
shorthand animal =
  animal.name ++ " (" ++ (toString animal.id) ++ ")"


type alias ContainsNameId record =
  { record | id : Int, name : String }

shorthand_second : ContainsNameId record -> String
shorthand_second record =
  record.name ++ " (" ++ (toString record.id) ++ ")"


comparison : Animal -> String
comparison ({name, id} as whole) = 
  "Which representation looks nicer?   \n" ++
  name ++ " (" ++ (toString id) ++ ")\n" ++
  "\n...or:\n   " ++
  toString whole



type Name = Name String String

formatName ((Name first last) as whole) =
  toString whole ++ ": " ++ last ++ ", " ++ first



type alias Inner =   
  { name : String
  , value : Maybe Int
  }

type alias Outer =
  { count : Int
  , inner : Inner
  }

outer =
  { count = 1
  , inner =
    { name = "Dawn"
    , value = Just "awesome"
    }
  }


new =
  let
    inner = outer.inner
  in
    { outer | inner = { inner | name = "X" } } 




record = { a = { part = "a", unchanged = "a" }
         , b = { part = "b", unchanged = "b" }
         , c = { part = 1, unchanged = "c" }
         }

updated =
  let 
    a = record.a
    b = record.b
    c = record.c
  in
    { record
      | a = { a | part = b.part }
      , b = { b | part = c.part }
      , c = { c | part = c.part + 1 }
    }

      
