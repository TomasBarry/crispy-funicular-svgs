module Interpreter (
    interpretStyle,
    drawingToSVG,
    interpretShape,
    interpretTransforms,
    inputDrawingsToSVG
) where

import Stylesheet
import Shapes
import Transforms
import Text.Blaze.Svg11 ((!))
import qualified Text.Blaze.Svg11 as S
import qualified Text.Blaze.Svg11.Attributes as A


-- Convert the DSL string to a renderable object
inputDrawingsToSVG :: Drawings -> S.Svg
inputDrawingsToSVG drawings = S.docTypeSvg
                                                    ! (A.version $ S.toValue "1.1")
                                                    ! (A.width $ S.toValue "1000")
                                                    ! (A.height $ S.toValue "1000")
                                                    ! (A.viewbox $ S.toValue "-100 -20 400 400") $ do
                                                        Prelude.foldl1 (>>) $ Prelude.map drawingToSVG drawings


-- Convert a single Drawing to a renderable object
drawingToSVG :: (Transform, Shape, Stylesheet) -> S.Svg

drawingToSVG (transforms, shape, styles) = Prelude.foldl (!) shape' (transform':styles')
    where
        transform' = A.transform $ interpretTransforms transforms
        shape' = interpretShape shape
        styles' = Prelude.map interpretStyle styles


interpretStyle :: Style -> S.Attribute
interpretStyle (FillColour c) = A.fill $ S.toValue $ show c
interpretStyle (StrokeColour c) = A.stroke $ S.toValue $ show c
interpretStyle (StrokeWidth w) = A.strokeWidth $ S.toValue w
interpretStyle (Xcoord x) = A.x $ S.toValue x
interpretStyle (Ycoord y) = A.y $ S.toValue y
interpretStyle (Width w) = A.width $ S.toValue w
interpretStyle (Height h) = A.height $ S.toValue h
interpretStyle (Radius r) = A.r $ S.toValue r


interpretShape :: Shape -> S.Svg
interpretShape Circle = S.circle
interpretShape Square = S.rect


interpretTransforms :: Transform -> S.AttributeValue
interpretTransforms (Identity)                        = S.translate 0 0
interpretTransforms (Translate (Vector x y)) = S.translate x y
interpretTransforms (Scale (Vector x y))        = S.scale x y
interpretTransforms (Rotate a)                       = S.rotate a
interpretTransforms (Compose a b)                = Prelude.mconcat [(interpretTransforms a), (interpretTransforms b)]
