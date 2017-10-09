module Choose.List_ exposing (..)

import Choose.MaybeLens as MaybeLens exposing (MaybeLens)

type List_ a
  = Cons a (List_ a)
  | Empty


first : MaybeLens (List_ a) a
first =
  let
    get list_ =
      case list_ of
        Empty ->
          Nothing
        Cons head _ ->
          Just head

    set new list_ =
      case list_ of
        Empty ->
          Cons new Empty
        Cons old tail ->
          Cons new tail
  in
    MaybeLens.make get set

rest : MaybeLens (List_ a) (List_ a)
rest =
  let
    get list_ =
      case list_ of
        Empty ->
          Nothing
        Cons _ tail ->
          Just tail
      
    set newTail list = 
      case list of
        Empty ->
          Empty
        Cons head tail ->
          Cons head newTail
  in
    MaybeLens.make get set
      
    
