# CS 4012 - Assignment 1

## Description
A web based interpreter for a shape DSL (Domain Specific Language).

## Running
This project is written in Haskell and makes use of Stack. Simply run `./run.sh` or alternatively `stack build` followed by `stack exec dsl`

## Extending the language
To add to the language, simply add to the desired data type in the relevant `.hs` file and then add an interpretation function in `Interpreter.hs`

For example, when adding width as a style to shapes the process was as follows:
  1. Add ```| Width Integer``` to the Style data type in `Stylesheet.hs`
  2. Add ```interpretStyle (Width w) = A.width $ S.toValue w``` to `Interpreter.hs`
