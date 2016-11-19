module Shapes(
  Shape (..), Point, Vector (..), Transform (..), Drawing, Style (..), Colour (..), Stylesheet,
  point, getX, getY,
  circle, square,
  identity, translate, rotate, scale, (<+>),
  shapeToSVG)  where

import Text.Blaze.Svg11 ((!))
import qualified Text.Blaze.Svg11 as S
import qualified Text.Blaze.Svg11.Attributes as A

data Vector = Vector Double Double
              deriving (Read, Show)
vector = Vector

cross :: Vector -> Vector -> Double
cross (Vector a b) (Vector a' b') = a * a' + b * b'

mult :: Matrix -> Vector -> Vector
mult (Matrix r0 r1) v = Vector (cross r0 v) (cross r1 v)

invert :: Double -> Double
invert a = -a

-- 2x2 square matrices are all we need.
data Matrix = Matrix Vector Vector
              deriving (Read, Show)

matrix :: Double -> Double -> Double -> Double -> Matrix
matrix a b c d = Matrix (Vector a b) (Vector c d)

getX (Vector x y) = x
getY (Vector x y) = y

-- Shapes

type Point  = Vector

point :: Double -> Double -> Point
point = vector


data Shape = Circle
           | Square
             deriving (Read, Show)

-- circle, square :: Shape

circle = Circle
square = Square


-- Transformations

data Transform = Identity
           | Translate Vector
           | Scale Vector
           | Compose Transform Transform
           | Rotate Double
             deriving (Show, Read)

identity = Identity
translate = Translate
scale = Scale
rotate angle = Rotate angle
t0 <+> t1 = Compose t0 t1

transform :: Transform -> Point -> Point
transform Identity                   x = id x
transform (Translate (Vector tx ty)) (Vector px py)  = Vector (px - tx) (py - ty)
transform (Scale (Vector tx ty))     (Vector px py)  = Vector (px / tx)  (py / ty)
transform (Rotate m)                 _ = Vector (invert m) (invert m)
transform (Compose t1 t2)            p = transform t2 $ transform t1 p


data Colour = Red
          | Black
          | Blue
          | Green
          deriving (Enum, Show, Read)


data Style = FillColour Colour
          | StrokeWidth Integer
          | StrokeColour Colour
          deriving (Show, Read)

type Stylesheet = [Style]

-- Drawings

type Drawing = [(Transform, Shape, Stylesheet)]


shapeToSVG :: Shape -> S.Svg
shapeToSVG Circle = S.circle ! A.r (S.toValue "4")
shapeToSVG Square = S.rect ! A.width (S.toValue "7") ! A.height (S.toValue "7")

