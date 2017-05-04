module Maybe.OneSolution exposing (..)

-- You can use this `import`:
--
--    import Maybe.OneSolution as One

toBool : Maybe a -> Bool
toBool maybe =
  case maybe of
    Just _ -> True    -- _ means you won't use the wrapped value
    Nothing -> False


               
join : Maybe (Maybe a) -> Maybe a
join nesting =
  case nesting of
    Just (Just wrapped) -> Just wrapped
    Just Nothing -> Nothing
    Nothing -> Nothing

-- or 
               
join2 : Maybe (Maybe a) -> Maybe a
join2 nesting =
  case nesting of
    Just (Just wrapped) -> Just wrapped
    _ -> Nothing


         
toList : Maybe a -> List a         
toList maybe = 
  case maybe of
    Just wrapped -> [wrapped]
    Nothing -> []
