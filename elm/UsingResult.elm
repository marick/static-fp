module UsingResult exposing (..)

-- mapMaybe : (a -> Maybe b) -> Result error a -> Result error b


numberPipe : String -> Result String (List Int)
numberPipe numberString =
  numberString 
    |> String.toInt
    |> Result.map (List.range 1)
    |> Result.map List.reverse


liftMaybe : (input -> Maybe result) -> error -> input
          -> Result error result
liftMaybe maybeProducer error input = 
    input |> maybeProducer |> Result.fromMaybe error

-- throughMaybe : ... -> Result error value -> Result error value
throughMaybe : (inValue -> Maybe outValue) -> error -> Result error inValue
             -> Result error outValue
throughMaybe f error result =
  case result of
    Err error -> Err error
    Ok value -> liftMaybe f error value 
               
       
listPipe : List String -> Result String (List Int)
listPipe numberList =
  numberList
    |> List.head |> Result.fromMaybe "List was empty"
    |> Result.andThen String.toInt
    |> Result.map (List.range 1)
    |> Result.map List.reverse








--     |> Result.map List.head |> Result.fromMaybe "no head")
  


-- workOnWrappedNumber : (Maybe number) -> Maybe number
-- workOnWrappedNumber =
--   Maybe.map ((*) 2) 


-- liftToResult : ((Maybe a) -> (Maybe b)) -> (Result error a) -> (Result error b)
-- liftToResult maybeF incoming =
--   case incoming of
--     Ok value ->
--       case maybeF of
--         Just outgoing -> Ok outgoing
--         Nothing ->                    
--     Err _ -> result
  
  
