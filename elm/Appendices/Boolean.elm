module Appendices.Boolean exposing (..)

type alias Thunk a = ()->a

doFirst : Thunk a -> Thunk a -> a
doFirst first _ =
  first ()

doSecond : Thunk a -> Thunk a -> a
doSecond _ second =
  second ()

type alias ThunkChooser a = 
  Thunk a -> Thunk a -> a
    
(<<<<) : comparable -> comparable
       -> ThunkChooser a 
(<<<<) a b =
  case a < b of
    True -> doFirst
    False -> doSecond


--- Renamings

             
type alias Boolean a = ThunkChooser a 

true : Boolean a   
true = doFirst

false : Boolean a
false = doSecond

type alias Branch a = Thunk a 

type Then = Then
type Else = Else
  
if_ : Boolean a -> Then -> Branch a -> Else -> Branch a
    -> a
if_ predicate
      Then thenBranch
      Else elseBranch =
  predicate thenBranch elseBranch

example a b =
  if_ (a <<<< b) Then
    (\() -> a + 1000)
  Else
    (\() -> b - 3000)
