module Optics.ExampleWithout exposing (..)

import Dict

{- An example of traversing a structure without
   optics modules.
-}

animal = { tags = ["mare"]
         , id = 3838
         }

id = 3838        

d = Dict.empty |> Dict.insert id animal
                     
model = { animals = d }

addTagToEnd id newTag model = 
  let
    updateTag animal =
      { animal | tags = animal.tags ++ [newTag]}
  in
    { model |
        animals = Dict.update id (Maybe.map updateTag) model.animals
    }


addTagToEnd2 id newTag model = 
  let
    updateTag animal =
      { animal | tags = animal.tags ++ [newTag]}
  in
    case Dict.get id model.animals of
      Nothing ->
        model
      (Just animal) ->
        { model |
            animals = Dict.insert id (updateTag animal) model.animals
        }
    

