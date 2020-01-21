module Calculations exposing (..)

import Setup


type alias Model =
    { factor : Setup.Model }


qual : Int -> Int
qual qualPlace =
    if qualPlace <= 0 then
        0

    else
        23 - qualPlace


aliances : Int -> Int -> Bool -> Int
aliances place choiceNum isHead =
    if isHead then
        17 - place

    else
        17 - choiceNum


finals : Float -> Bool -> Model -> Float
finals sum win model =
    if win then
        sum + 5.0 * model.factor.einsteinFactor

    else
        sum
