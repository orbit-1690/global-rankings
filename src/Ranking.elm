module Ranking exposing (Model, Msg, init, update, view)

import Debug exposing (todo)
import Element
import Zipper exposing (Zipper, makeZipper)


type alias Model =
    { teams : Zipper (Zipper Team)
    , isShowingInfo : Bool
    }


type Msg
    = Debug


type alias Team =
    { number : Int
    , name : String
    , score : Float
    }


zipp : Zipper Team
zipp =
    makeZipper []
        { number = 1
        , name = ""
        , score = 1
        }
        []


init : Model
init =
    { teams = makeZipper [ zipp ] zipp [ zipp ]
    , isShowingInfo = False
    }


view : Model -> Element.Element Msg
view model =
    Debug.todo "add view"


update : Msg -> Model -> Model
update msg model =
    Debug.todo "add update"
