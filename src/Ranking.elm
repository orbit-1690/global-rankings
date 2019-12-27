module Ranking exposing (Model, Msg, init, update, view)

import Debug exposing (todo)
import Zipper exposing (Zipper)


type alias Model =
    { teams : Zipper (Zipper Team)
    , isShowingInfo : Bool
    }


type alias Team =
    { number : Int
    , name : String
    , score : Float
    }
