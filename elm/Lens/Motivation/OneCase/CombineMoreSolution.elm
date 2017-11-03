module Lens.Motivation.BoxSolution exposing (..)

import Lens.Try3.Lens as Lens
import Lens.Try3.Maybe as Maybe

type alias Animal =
  { name : String
  , species : String
  }

type alias FormData =
  { newName : Maybe String
  , newTag : Maybe String
  }

type AnimalView 
  = Compact Animal
  | Expanded Animal
  | Editable Animal FormData


--



compact : Lens.OneCase AnimalView Animal
compact =
  let 
    get big =
      case big of
        Compact animal ->
          Just animal
        _ ->
          Nothing
  in
    Lens.oneCase get Compact

expanded : Lens.OneCase AnimalView Animal
expanded =
  let 
    get big =
      case big of
        Expanded animal ->
          Just animal
        _ ->
          Nothing
  in
    Lens.oneCase get Expanded

editable : Lens.OneCase AnimalView (Animal, FormData)
editable =
  let 
    get big =
      case big of
        Editable animal formData ->
          Just (animal, formData)
        _ ->
          Nothing
            
    set (animal, formData) =
      Editable animal formData
  in
    Lens.oneCase get set

betsy : Animal
betsy = { name = "Betsy", species = "bovine" }

compactCow : AnimalView        
compactCow = Compact betsy
             
expandedCow : AnimalView
expandedCow = Expanded betsy 

editableCow : AnimalView
editableCow = Editable betsy { newName = Nothing, newTag = Nothing }




