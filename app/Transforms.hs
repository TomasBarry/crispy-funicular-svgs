module Transforms (
    Vector (..),
    Transform (..)
) where

data Vector = Vector Double Double
    deriving (Show, Read)

data Transform = Identity
           | Translate Vector
           | Scale Vector
           | Compose Transform Transform
           | Rotate Double
             deriving (Show, Read)
