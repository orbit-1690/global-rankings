module Setup exposing (Model, Msg, init, update, view)

import Debug exposing (todo)


type alias Model =
    { startYear : Int
    , endYear : Int
    , einsteinFactor : Float
    , districtFactor : Float
    , playOffFactor : Float
    , offSeasonFactor : Float
    }


type Msg
    = StartYear Int
    | EndYear Int
    | EinsteinFactor Int
    | DistrictFactor Float
    | PlayOffFactor Float
    | OffSeasonFactor Float
    | Continue
