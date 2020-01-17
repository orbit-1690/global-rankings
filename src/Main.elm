module Main exposing (Model, Msg, init, update, view)

import Browser
import Colors exposing (black, blue, blueGreen, lightBlue, orange, purple, sky, white)
import Element exposing (centerX, centerY, column, el, fill, height, html, layout, maximum, padding, rgb255, shrink, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (center)
import Element.Input as Input exposing (button)
import Http
import Json.Decode as JD
import Maybe
import Ranking
import RemoteData
import Setup exposing (Model)
import String


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = view >> layout []
        , update = update
        , subscriptions = always Sub.none
        }


type Pages
    = Setup
    | Ranking


type Msg
    = RankingM Ranking.Msg
    | SetupM Setup.Msg
    | Switch
    | GotRankings (RemoteData.RemoteData Http.Error TeamRankings)


type alias TeamRankings =
    List RankedTeam


type alias RankedTeam =
    { name : String
    , position : Int
    }


type alias Model =
    { setup : Setup.Model
    , ranking : Ranking.Model
    , pages : Pages
    , rankings : RemoteData.RemoteData Http.Error TeamRankings
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


rankingParser : JD.Decoder TeamRankings
rankingParser =
    JD.map2 RankedTeam (JD.field "team_key" JD.string) (JD.field "rank" JD.int)
        |> JD.list
        |> JD.field "rankings"


init : ( Model, Cmd Msg )
init =
    ( { setup = Setup.init 1 1 1 1 2017 2020
      , ranking = Ranking.init
      , pages = Setup
      , rankings = RemoteData.Loading
      }
    , Http.get
        { url = "http://localhost:1690/TBA"
        , expect = Http.expectJson (GotRankings << RemoteData.fromResult) rankingParser
        }
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RankingM rMsg ->
            ( { model | ranking = Ranking.update rMsg model.ranking }, Cmd.none )

        SetupM sMsg ->
            ( { model | setup = Setup.update sMsg model.setup }, Cmd.none )

        Switch ->
            if model.pages == Ranking then
                ( { model | pages = Setup }, Cmd.none )

            else
                ( { model | pages = Ranking }, Cmd.none )

        GotRankings rankings ->
            ( { model | rankings = rankings }, Cmd.none )



{-
   = BadUrl String
    | Timeout
    | NetworkError
    | BadStatus Int
    | BadBody String

-}


view : Model -> Element.Element Msg
view model =
    let
        rankingDisplay : Element.Element Msg
        rankingDisplay =
            case rankings of
                Err httpError ->
                    case httpError of
                        Http.BadUrl badUrl ->
                            Element.text <| "bad url" ++ badUrl

                        Http.Timeout ->
                            let
                                _ =
                                    Debug.log "timeout" ""
                            in
                            Element.none
                        Http.NetworkError ->
                            let
                                _ =
                                    Debug.log "network error" ""
                            in
                            Element.none

                        Http.BadStatus code ->
                            let
                                _ =
                                    Debug.log "bad status:" <| String.fromInt code
                            in
                            Element.none

                        Http.BadBody body ->
                            let
                                _ =
                                    Debug.log "bad body" body
                            in
                            Element.none
                Ok validRanking ->
                    Debug.todo ""
    in 

    case model.pages of
        Setup ->
            column [ Element.centerX, Element.moveDown 200, Element.scale 1.9 ]
                [ Element.map SetupM <| Setup.view model.setup
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
                [ Element.map RankingM <| Ranking.view model.ranking
                , switchButton "previous"
                , 
                ]
