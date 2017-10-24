module Lens.Try3.Compose.Pipeline exposing (..)

import Lens.Try3.Lens as Lens
import Lens.Try3.Compose exposing (..)


cc : Lens.Classic b c -> Lens.Classic a b -> Lens.Classic a c
cc = flip classicAndClassic

cu : Lens.Upsert b c -> Lens.Classic a b -> Lens.Upsert a c
cu = flip classicAndUpsert
             
uc : Lens.Classic b c -> Lens.Upsert a b -> Lens.Iffy a c
uc = flip upsertAndClassic

ii : Lens.Iffy b c -> Lens.Iffy a b -> Lens.Iffy a c
ii = flip iffyAndIffy

