module Main exposing (Model, Msg, init, update, view)

import Browser
import Colors exposing (black, blue, blueGreen, lightBlue, orange, purple, sky, white)
import Element exposing (centerX, centerY, column, el, fill, height, html, layout, maximum, padding, rgb255, shrink, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (center)
import Element.Input as Input exposing (button)
import Maybe
import Ranking
import Setup exposing (Model)
import String


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view >> layout []
        , update = update
        }


type Pages
    = Setup
    | Ranking


type Msg
    = RankingMsg Ranking.Msg
    | SetupMsg Setup.Msg
    | Switch


type alias Model =
    { setup : Setup.Model
    , ranking : Ranking.Model
    , pages : Pages
    }


switchButton : String -> Element.Element Msg
switchButton string =
    el
        [ Element.centerX
        , Element.centerY
        , Element.moveDown 40
        , width fill
        , height fill
        , Font.size 40
        ]
    <|
        Input.button
            [ Border.rounded 8
            , Background.gradient
                { angle = 2
                , steps = [ purple, orange, blueGreen ]
                }
            , center
            , Element.centerX
            , Element.centerY
            ]
            { onPress = Just Switch
            , label = text string
            }


init : Model
init =
    { setup = Setup.init 1 1 1 1 2017 2020
    , ranking = Ranking.init
    , pages = Setup
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        RankingMsg rMsg ->
            { model | ranking = Ranking.update rMsg model.ranking }

        SetupMsg sMsg ->
            { model | setup = Setup.update sMsg model.setup }

        Switch ->
            if model.pages == Ranking then
                { model | pages = Setup }

            else
                { model | pages = Ranking }


view : Model -> Element.Element Msg
view model =
    case model.pages of
        Setup ->
            column [ Element.centerX, Element.moveDown 200, Element.scale 1.9 ]
                [ Element.map SetupMsg <| Setup.view model.setup
                , switchButton "next"
                ]

        Ranking ->
            column
                [ Background.color lightBlue
                , padding 10
                , spacing 10
                , width fill
                , height fill
                ]
                [ Element.map RankingMsg <| Ranking.view model.ranking
                , switchButton "previous"
                ]



-- easterEgg : Model -> Element.Element Msg
-- easterEgg model =
--     el [] <|
--         Element.text "you entered easter egg mode\n\n\n\n\n you will die soon\n\n\n\n\n\n\n\n\nboom!!!!\n\n☺☻☺☻§"
