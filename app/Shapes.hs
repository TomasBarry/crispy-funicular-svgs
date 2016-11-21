module Shapes(
  Shape (..),
  Drawings
)  where

import Stylesheet
import Transforms


data Shape = Circle
           | Square
             deriving (Read, Show)


type Drawing = (Transform, Shape, Stylesheet)

type Drawings = [Drawing]

