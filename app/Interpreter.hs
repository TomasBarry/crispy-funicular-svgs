{-# LANGUAGE OverloadedStrings #-}

module Interpreter (interpretStyle, interpretShape, interpretTransforms, drawingToSVG, inputDrawingsToSVG) where

import Stylesheet
import Shapes
import Text.Blaze.Svg11 ((!))
import qualified Text.Blaze.Svg11 as S
import qualified Text.Blaze.Svg11.Attributes as A


inputDrawingsToSVG :: Drawings -> S.Svg
inputDrawingsToSVG drawings = S.docTypeSvg ! A.version "1.1" ! A.width "1000" ! A.height "1000" ! A.viewbox "-100 -20 1000 1000" $ do
                                          Prelude.foldl1 (>>) $ Prelude.map drawingToSVG drawings


nestTransformDos :: ([S.AttributeValue], Shape, Stylesheet) -> S.Svg
nestTransformDos ([], shape, styles) = Prelude.foldl (!) (interpretShape shape) (Prelude.map interpretStyle styles)
nestTransformDos ((transform:transfoms), shape, styles) = S.g ! A.transform transform $ do (nestTransformDos (transfoms, shape, styles))



drawingToSVG :: (Transform, Shape, Stylesheet) -> S.Svg
drawingToSVG (transforms, shape, styles) = nestTransformDos (interpretTransforms transforms, shape, styles)


-- For each Style in Stylesheet.hs, add an interpreter here

interpretStyle :: Style -> S.Attribute
interpretStyle (FillColour c) = A.fill $ S.toValue $ show c
interpretStyle (StrokeColour c) = A.stroke $ S.toValue $ show c
interpretStyle (StrokeWidth w) = A.strokeWidth $ S.toValue w
interpretStyle (Xcoord x) = A.x $ S.toValue x
interpretStyle (Ycoord y) = A.y $ S.toValue y
interpretStyle (Width w) = A.width $ S.toValue w
interpretStyle (Height h) = A.height $ S.toValue h
interpretStyle (Radius r) = A.r $ S.toValue r


-- For each Shape in Shapes.hs, add an interpreter here

interpretShape :: Shape -> S.Svg
interpretShape Circle = S.circle
interpretShape Square = S.rect


-- For each Transform in Transforms.hs, add an interpreter here

interpretTransforms :: Transform -> [S.AttributeValue]
interpretTransforms (Identity)                        = [S.translate 0 0]
interpretTransforms (Translate (Vector x y)) = [S.translate x y]
interpretTransforms (Scale (Vector x y))        = [S.scale x y]
interpretTransforms (Rotate a)                       = [S.rotate a]
interpretTransforms (Compose a b)                = Prelude.concat [(interpretTransforms a), (interpretTransforms b)]
