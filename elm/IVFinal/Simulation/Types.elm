module IVFinal.Simulation.Types exposing
  ( Stage(..)
  , HowFinished(..)
  )

{- Interface types used by both simulation code and by other parts of
the app.
-}

import IVFinal.Generic.Measures as Measure

-- Just for clarity in sum type
type alias DrainRate = Measure.LitersPerMinute

{- From the user's point of view, the app proceeds through three stages:
the one before the simulation (filling out the form), the one during the
simulation (watching the fluid level descend), and the one after the simulation. 
This type represents those stages.
-}
type Stage
  = FormFilling 
  | WatchingAnimation DrainRate
  | Finished DrainRate HowFinished

{- There are two relevant results of a simulation:
* the fluid descended in the bag, then stopped
* the fluid ran out before the simulation ended

This type captures those, and also include the information used
to communicate what's special about the result.
-}
type HowFinished
  = FluidLeft Measure.Liters
  | RanOutAfter Measure.Minutes


  
