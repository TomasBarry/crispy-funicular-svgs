module Stylesheet (
    Stylesheet (..), Style (..)) where

import qualified Colours as C

data Style = FillColour C.Colour
          | StrokeWidth Integer
          | StrokeColour C.Colour
          | Xcoord Integer
          | Ycoord Integer
          | Width Integer
          | Height Integer
          | Radius Integer
          deriving (Show, Read)

type Stylesheet = [Style]
