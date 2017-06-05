module Records.Basic exposing (..)

-- friendlyName : { record | name : String, id : Int } -> String
-- friendlyName animal =
--   animal.name ++ " (" ++ (toString animal.id) ++ ")"


-- shorthand : Animal -> String
-- shorthand animal =
--   animal.name ++ " (" ++ (toString animal.id) ++ ")"

hi : { record | name : String } -> String
hi record =
  "Hi " ++ record.name 

type alias Animal =
  { id : Int
  , name : String
  , tags : List String
  }


bossie : Animal  
bossie =
  { id = 13837
  , name = "bossie"
  , tags = ["heifer"]
  }
  

type alias ContainsNameId record =
  { record | id : Int, name : String }

shorthand : ContainsNameId record -> String
shorthand record =
  record.name ++ " (" ++ (toString record.id) ++ ")"


ex1maker : String -> { name : String, id : Int }
ex1maker name =
  { name = name, id = 3 }

ex1taker : { id : Int } -> Int
ex1taker record =
  record.id
        

    

-- x : ContainsNameId { id : Float, name : Float }
-- x = { id = 3 , name = "foo"}    
    
-- bossie =
--   { id = 13837
--   , name = "bossie"
--   , tags = ["heifer"]
--   }


-- bossie : Animal
-- bossie =
--   { id = 13837
--   , name = "bossie"
--   , tags = []
--   }

-- jake : Animal
-- jake =
--   { id = 13838
--   , name = "jake"
--   , tags = ["stallion"]
--   }

-- bossie2 : Animal  
-- bossie2 = { bossie | name = "Bossy", tags = ["cow"] }

-- shorthand : Animal -> String
-- shorthand {name, id} =
--   name ++ " (" ++ (toString id) ++ ")"

-- comparison : Animal -> String
-- comparison ({name, id} as whole) = 
--   "Which is better?   \n" ++
--   name ++ " (" ++ (toString id) ++ ")\n" ++
--   "\n...or:\n   " ++
--   toString whole

-- restrictiveName : { id : Int
--                   , name : String
--                   , tags : List String
--                   } -> String
-- restrictiveName {name, id} =
--   name ++ " (" ++ (toString id) ++ ")"
    
-- shorthanddIdThing_broke : { id : Int
--                              , name : String
--                              } -> String
-- shorthanddIdThing_broke {name, id} =
--   name ++ " (" ++ (toString id) ++ ")"


-- shorthanddIdThing : { whole | id : Int, name : String } -> String    
-- shorthanddIdThing {name, id} =
--   name ++ " (" ++ (toString id) ++ ")"
    
-- -- AuditedName whole = { whole | id : Int, name : String }


-- setName : String -> Animal -> Animal
-- setName newName animal =
--   { animal | name = newName }



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
