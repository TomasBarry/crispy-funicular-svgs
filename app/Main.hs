{-# LANGUAGE OverloadedStrings #-}


import Web.Scotty
import Shapes
import Data.Text.Lazy
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
