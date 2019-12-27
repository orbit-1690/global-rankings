module RankingMain exposing (Model, Msg, init, update, view)

import Browser
import Colors exposing (black, blue, blueGreen, lightBlue, orange, purple, sky, white)
import Element exposing (centerX, centerY, column, fill, height, html, layout, maximum, padding, rgb255, shrink, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (center)
import Element.Input as Input exposing (button)
import Maybe
import Ranking
import String


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view >> layout []
        , update = update
        }


type Pages
    = Page1
    | Page2


type Msg
    = Rank1_10 Ranking.Msg
    | Rank11_20 Ranking.Msg
    | NextPage1To2
    | PrevPage2To1


type alias Model =
    { rank1_10 : Ranking.Model
    , rank11_20 : Ranking.Model
    , pages : Pages
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Rank1_10 tmsg ->
            { model | rank1_10 = Ranking.update tmsg model.rank1_10 }

        Rank11_20 amsg ->
            { model | rank11_20 = Ranking.update amsg model.rank11_20 }

        NextPage1To2 ->
            { model | pages = Page2 }

        PrevPage2To1 ->
            { model | pages = Page1 }


view : Model -> Element.Element Msg
view model =
    case model.pages of
        Page1 ->
            column
                [ Background.color lightBlue
                , padding 10
                , spacing 10
                , width fill
                , height fill
                ]
                [ Element.map Rank1_10 <|
                    html <|
                        Ranking.view model.rank1_10
                , button
                    [ Border.rounded 10
                    , Background.gradient
                        { angle = 2
                        , steps = [ purple, orange, blueGreen ]
                        }
                    , center
                    , centerX
                    , centerY
                    , width <| maximum 350 <| fill
                    ]
                    { onPress = Just <| NextPage1To2
                    , label = Element.text "Next Page"
                    }
                ]

        Page2 ->
            column
                [ Background.color lightBlue
                , padding 10
                , spacing 10
                , width fill
                , height fill
                ]
                [ Element.map Rank11_20 <|
                    html <|
                        Ranking.view model.rank11_20
                , button
                    [ Border.rounded 10
                    , Background.gradient
                        { angle = 2
                        , steps = [ purple, orange, blueGreen ]
                        }
                    , center
                    , centerX
                    , centerY
                    , width <| maximum 350 <| fill
                    ]
                    { onPress = Just <| PrevPage2To1
                    , label = Element.text "Previous Page"
                    }
                ]


init : Model
init =
    { rank1_10 = Ranking.init "Top 10"
    , rank11_20 = Ranking.init "11 - 20"
    , pages = Page1
    }
