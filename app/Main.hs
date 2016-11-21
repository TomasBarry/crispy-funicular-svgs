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




inputDrawingsToSVG :: Drawings -> S.Svg
inputDrawingsToSVG drawings = S.docTypeSvg ! A.version "1.1" ! A.width "150" ! A.height "100" ! A.viewbox "0 0 150 100" $ do
                                          Prelude.foldl1 (>>) $ Prelude.map drawingToSVG drawings


main = scotty 3000 $ do

  get "/" $ do
    dsl_query <- param "dsl_query"
    let drawing = read dsl_query :: Drawings
    let a = renderSvg $ inputDrawingsToSVG drawing
    html $ pack a
