module Interpreter (interpretStyle, interpretShape) where

import Stylesheet
import Shapes
import qualified Text.Blaze.Svg11 as S
import qualified Text.Blaze.Svg11.Attributes as A


-- For each Style in Stylesheet.hs, add an interpreter here

interpretStyle :: Style -> S.Attribute
interpretStyle (FillColour c) = A.fill $ S.toValue $ show c
interpretStyle (StrokeColour c) = A.stroke $ S.toValue $ show c
interpretStyle (StrokeWidth w) = A.strokeWidth $ S.toValue w
interpretStyle (Xcoord x) = A.x $ S.toValue x
interpretStyle (Ycoord y) = A.y $ S.toValue y
interpretStyle (Width w) = A.width $ S.toValue w
interpretStyle (Height h) = A.height $ S.toValue h
interpretStyle (Radius r) = A.radius $ S.toValue r


-- For each Shape in Shapes.hs, add an interpreter here

interpretShape :: Shape -> S.Svg
interpretShape Circle = S.circle
interpretShape Square = S.rect

