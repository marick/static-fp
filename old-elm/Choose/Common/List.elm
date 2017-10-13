module Choose.Common.List exposing
  ( first
  , rest
  )

import Choose.MaybeLens as MaybeLens exposing (MaybeLens)

first : MaybeLens (List a) a
first =
  let
    get =
      List.head

    set val list =
      val :: (List.drop 1 list)
  in
    MaybeLens.make get set

rest : MaybeLens (List a) (List a)
rest =
  let
    get =
      List.tail

    set val list = 
      case list of
        [] -> []
        x :: xs -> x :: val
  in
    MaybeLens.make get set
      
