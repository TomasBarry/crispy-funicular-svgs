module Shapes(
  Shape (..), Vector (..), Transform (..), Drawings)  where

import Stylesheet
import Transforms


data Shape = Circle
           | Square
             deriving (Read, Show)



type Drawings = [(Transform, Shape, Stylesheet)]

