module Records where

import Prelude

newtype Animal = Animal
  { id :: Int
  , name :: String
  , tags :: Array String
  }

f = 33

-- bossie :: Animal
-- bossie = { id: 13837, name: "bossie", tags: [] }

-- jake :: Animal
-- jake =
--   { id :: 13838
--   , name :: "jake"
--   , tags :: ["stallion"]
--   }

-- bossie2 :: Animal  
-- bossie2 = bossie { name = "Bossy", tags = ["cow"] }

-- friendlyName :: Animal -> String
-- friendlyName {name, id} =
--   name <> " (" <> (show id) <> ")"



-- comparison :: Animal -> String
-- comparison ({name, id} as whole) = 
--   "Which is better?   \n" ++
--   name ++ " (" ++ (toString id) ++ ")\n" ++
--   "\n...or:\n   " ++
--   toString whole
