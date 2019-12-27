module Main exposing (init, main, update, view)

import Browser
import Element exposing (centerX, centerY, el, fill, height, html, layout, map, maximum, padding, rgb255, shrink, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font exposing (center)
import Element.Input exposing (button)
import Ranking
import Setup


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = layout [] << view
        , update = update
        }


type Msg
    = SetupMsg Setup.Msg
    | RankingMsg Ranking.Msg
    | SwitchView


type alias Model =
    { setupModel : Setup.Model
    , rankingModel : Ranking.Model
    , switchButton : Bool
    }


type CurrentScreen
    = Setup
    | Ranking


init : Model
init =
    { setupModel = Setup.init
    , rankingModel = Ranking.init
    , switchButton = False
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetupMsg setupMsg ->
            { model | setupModel = Setup.update setupMsg model.setupModel }

        RankingMsg rankingMsg ->
            { model | rankingModel = Ranking.update rankingMsg model.rankingModel }

        SwitchView ->
            { model | switchButton = not model.switchButton }


view : Model -> Element.Element Msg
view model =
    let
        switchButton =
            button []
                { onPress = Just SwitchView
                , label = text "switch view"
                }
    in
    if model.switchButton then
        el [ centerX, centerY ]
            << map RankingMsg
            << Ranking.view
        <|
            model.rankingModel

    else
        el [ centerX, centerY ]
            << map SetupMsg
            << Setup.view
        <|
            model.setupModel
