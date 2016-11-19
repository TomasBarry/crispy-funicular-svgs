{-# LANGUAGE OverloadedStrings #-}


import Web.Scotty
import Shapes
import Data.Text.Lazy
import Text.Blaze.Svg11 ((!))
import qualified Text.Blaze.Svg11 as S
import qualified Text.Blaze.Svg11.Attributes as A
import Text.Blaze.Svg.Renderer.String (renderSvg)


stringToDrawing:: String -> Drawing
stringToDrawing x = read x

-- shapeToSVG :: Shape -> S.Svg
-- shapeToSVG Circle = S.circle ! A.r (S.toValue "4")
-- shapeToSVG Square = S.rect ! A.width (S.toValue "7") ! A.height (S.toValue "7")

interpretStyleSheet :: Style -> S.Attribute
interpretStyleSheet (FillColour Blue) = A.fill "blue"
interpretStyleSheet (FillColour Black) = A.fill "black"
interpretStyleSheet (FillColour Red) = A.fill "red"
interpretStyleSheet (FillColour Green) = A.fill "green"

interpretStyleSheet (StrokeColour Blue) = A.stroke "blue"
interpretStyleSheet (StrokeColour Black) = A.stroke "black"
interpretStyleSheet (StrokeColour Red) = A.stroke "red"
interpretStyleSheet (StrokeColour Green) = A.stroke "green"

interpretStyleSheet (StrokeWidth x) = A.strokeWidth $ S.toValue x


svgDoc :: (Transform, Shape, Stylesheet) -> S.Svg
svgDoc (Identity, s, styles) =                        Prelude.foldl (!) (shapeToSVG s) (Prelude.map interpretStyleSheet styles)
svgDoc (Translate (Vector x y), s, styles) = (Prelude.foldl (!) (shapeToSVG s) (Prelude.map interpretStyleSheet styles)) ! (A.transform $ S.translate x y)
svgDoc (Scale (Vector x y), s, styles) =        (Prelude.foldl (!) (shapeToSVG s) (Prelude.map interpretStyleSheet styles)) ! (A.transform $ S.scale x y)
svgDoc (Rotate x, s, styles) =                       (Prelude.foldl (!) (shapeToSVG s) (Prelude.map interpretStyleSheet styles)) ! (A.transform $ S.rotate x)


inputToSVG :: Drawing -> S.Svg
inputToSVG drawings = S.docTypeSvg ! A.version "1.1" ! A.width "150" ! A.height "100" ! A.viewbox "0 0 10 10" $ do
                                          Prelude.foldl1 (>>) $ Prelude.map svgDoc drawings


main = scotty 3000 $ do

  get "/" $ do
    dsl_query <- param "dsl_query"
    let drawing = stringToDrawing dsl_query
    let a = renderSvg $ inputToSVG drawing
    html $ pack a
