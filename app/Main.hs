{-# LANGUAGE OverloadedStrings #-}


import Web.Scotty
import Shapes
import Stylesheet
import Transforms
import Data.Text.Lazy
import Data.Colour.Names as CN
import Text.Blaze.Svg11 ((!))
import qualified Text.Blaze.Svg11 as S
import qualified Text.Blaze.Svg11.Attributes as A
import Interpreter
import Text.Blaze.Svg.Renderer.String (renderSvg)


stringToDrawing:: String -> Drawing
stringToDrawing x= read x


svgDoc :: (Transform, Shape, Stylesheet) -> S.Svg
svgDoc (Identity, s, styles)                        = (Prelude.foldl (!) (interpretShape s) (Prelude.map interpretStyle styles))
svgDoc (Translate (Vector x y), s, styles) = (Prelude.foldl (!) (interpretShape s) (Prelude.map interpretStyle styles)) ! (A.transform $ S.translate x y)
svgDoc (Scale (Vector x y), s, styles)        = (Prelude.foldl (!) (interpretShape s) (Prelude.map interpretStyle styles)) ! (A.transform $ S.scale x y)
svgDoc (Rotate x, s, styles)                       = (Prelude.foldl (!) (interpretShape s) (Prelude.map interpretStyle styles)) ! (A.transform $ S.rotate x)


inputToSVG :: Drawing -> S.Svg
inputToSVG drawings = S.docTypeSvg ! A.version "1.1" ! A.width "150" ! A.height "100" ! A.viewbox "0 0 10 10" $ do
                                          Prelude.foldl1 (>>) $ Prelude.map svgDoc drawings


main = scotty 3000 $ do

  get "/" $ do
    dsl_query <- param "dsl_query"
    let drawing = stringToDrawing dsl_query
    let a = renderSvg $ inputToSVG drawing
    html $ pack a
