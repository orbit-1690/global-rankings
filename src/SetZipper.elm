module SetZipper exposing (Model, RankedTeam, TeamRankings, createZipper)

import Browser
import Colors exposing (black, blue, blueGreen, lightBlue, orange, purple, sky, white)
import Element exposing (centerX, centerY, column, el, fill, height, html, layout, maximum, padding, rgb255, shrink, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (center)
import Element.Input as Input exposing (button)
import Http
import Json.Decode as JD
import List.Zipper exposing (Zipper, fromCons)
import Maybe
import RemoteData
import String


type alias TeamRankings =
    List RankedTeam


type alias RankedTeam =
    { name : String
    , position : Int
    }


type alias Model =
    { rankings : RemoteData.RemoteData Http.Error TeamRankings }


rankingDisplay : Model -> TeamRankings
rankingDisplay model =
    case model.rankings of
        RemoteData.Success validRanking ->
            validRanking

        _ ->
            let
                _ =
                    Debug.log "didn't succeed"
            in
            []


createZipper : Model -> Zipper RankedTeam
createZipper model =
    fromCons { name = "Open", position = 0 } <| rankingDisplay model
