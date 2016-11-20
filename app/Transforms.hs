module Transforms (Transform (..), Vector (..)) where


data Vector = Vector Double Double
              deriving (Read, Show)


-- 2x2 square matrices are all we need.
data Matrix = Matrix Vector Vector
              deriving (Read, Show)

data Transform = Identity
           | Translate Vector
           | Scale Vector
           | Compose Transform Transform
           | Rotate Double
             deriving (Show, Read)
