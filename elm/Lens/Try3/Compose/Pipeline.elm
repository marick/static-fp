module Lens.Try3.Compose.Pipeline exposing (..)

import Lens.Try3.Lens exposing (..)
import Lens.Try3.Compose exposing (..)


cc : ClassicLens b c -> ClassicLens a b -> ClassicLens a c
cc = flip classicAndClassic

cu : UpsertLens b c -> ClassicLens a b -> UpsertLens a c
cu = flip classicAndUpsert
             
uc : ClassicLens b c -> UpsertLens a b -> IffyLens a c
uc = flip upsertAndClassic

ii : IffyLens b c -> IffyLens a b -> IffyLens a c
ii = flip iffyAndIffy

