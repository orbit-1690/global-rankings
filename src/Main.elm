module Main exposing (init, main, update, view)

import Browser
import Element exposing (centerX, centerY, el, layout, map, text)
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
    { setup : Setup.Model
    , ranking : Ranking.Model
    , screen : CurrentScreen
    }


type CurrentScreen
    = Setup
    | Ranking


init : Model
init =
    { setup = Setup.init
    , ranking = Ranking.init
    , screen = Setup
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetupMsg setupMsg ->
            { model | setup = Setup.update setupMsg model.setup }

        RankingMsg rankingMsg ->
            { model | ranking = Ranking.update rankingMsg model.ranking }

        SwitchView ->
            { model
                | screen =
                    case model.screen of
                        Setup ->
                            Ranking

                        Ranking ->
                            Setup
            }


view : Model -> Element.Element Msg
view model =
    let
        switchScreen =
            button []
                { onPress = Just SwitchView
                , label = text "switch view"
                }

        element xMsg xView xModel =
            el [ centerX, centerY ]
                << map xMsg
                << xView
            <|
                xModel model
    in
    case model.screen of
        Setup ->
            element SetupMsg Setup.view .setup

        Ranking ->
            element RankingMsg Ranking.view .ranking
