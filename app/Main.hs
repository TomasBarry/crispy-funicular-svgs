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


main = scotty 3000 $ do

  get "/" $ do
    file "./app/index.html"

  post "/rendersvgs" $ do
    dsl_query <- param "dsl_query"
    let drawing = read dsl_query :: Drawings
    let a = renderSvg $ inputDrawingsToSVG drawing
    html $ pack a
