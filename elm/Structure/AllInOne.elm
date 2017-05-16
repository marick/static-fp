module Structure.AllInOne exposing (..)

type StringCell
  = WithString String FloatCell

type FloatCell
  = WithFloat Float StringCell
  | Stop

example =     
  WithString "first"
    <| WithFloat 1.3
      <| WithString "second" Stop
  
