module Shapes(
  Shape (..), Vector (..), Transform (..), Drawing)  where

import Stylesheet
import Transforms


data Shape = Circle
           | Square
             deriving (Read, Show)



type Drawing = [(Transform, Shape, Stylesheet)]

