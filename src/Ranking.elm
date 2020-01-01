module Ranking exposing (Model, Msg, init, update, view)

import Debug exposing (todo)
import Element
import List.Zipper exposing (Zipper, from)


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


zipper : Zipper Team
zipper =
    from []
        { number = 1
        , name = ""
        , score = 1
        }
        []


init : Model
init =
    { teams = from [ zipper ] zipper [ zipper ]
    , isShowingInfo = False
    }


view : Model -> Element.Element Msg
view model =
    Debug.todo "add view"


update : Msg -> Model -> Model
update msg model =
    Debug.todo "add update"
