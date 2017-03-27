module SumTypes.WholeStory exposing (..)

type Silly a b
  = AsA a
  | AsB b
  | AlsoAsA a

  | AsInt Int

  | AsIntString Int String
  | AsBoth a b
  | AsIntB Int b

  | AsMaybe (Maybe a)
  | AsMaybeInt (Maybe Int)
  | DeeplySilly (Silly a a) (Silly Int b)
  | NoArg

becomeSilly1 : Int -> b    -> Silly Int b
becomeSilly1 a b -> AsBoth a b
                    
becomeSilly2 : a   -> Int  -> Silly a   Int
becomeSilly2 a b -> AsBoth a b

becomeSilly3 : Int -> Bool -> Silly Int Bool
becomeSilly3 a b -> AsBoth a b

becomeSilly4 : a -> b -> Silly a b
becomeSilly4 a b -> AsBoth a b
    
    
fun1 : (Silly Float b) -> Int
fun1 ignored = 5
       
fun2 : (Silly Float b) -> Int
fun2 ignored = 5
       
fun3 : (Silly a b) -> Int
fun3 ignored = 5
       
fun4 : (Silly String b) -> Int
fun4 ignored = 5

sample =
  DeeplySilly
    (DeeplySilly
       (AsMaybe (Just []))
       (AsIntB 3 []))
    (AsInt 3)
               
    
