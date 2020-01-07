module SetZipper exposing (..)

import Debug exposing (todo)
import List.Zipper exposing (Zipper, fromList)


type alias Team =
    { number : Int
    , name : String
    , score : Float
    }


crateZipper : Zipper (Zipper Team)
crateZipper =
    Debug.todo "crate zipper"
