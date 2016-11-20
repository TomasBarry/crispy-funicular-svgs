module Colours(
    Colour(..)) where


-- Add colours to the below data type to expand valid colours in the language

data Colour = Red
          | Black
          | Blue
          | Green
          deriving (Enum, Show, Read)
