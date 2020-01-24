module Ranking exposing (Model, Msg, init, update, view)

import Browser
import Colors exposing (black, blue, blueGreen, lightBlue, orange, purple, sky, white)
import Element exposing (alignLeft, alignRight, centerX, centerY, column, el, fill, height, html, layout, maximum, padding, rgb255, shrink, spacing, table, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (center)
import Element.Input as Input exposing (button)
import Http
import Json.Decode as JD
import List.Extra exposing (count, getAt, takeWhileRight)
import List.Zipper exposing (Zipper, after, current, fromCons, isLast, next, toList, withDefault)
import Maybe
import RemoteData
import SetZipper exposing (RankedTeam, TeamRankings)
import Setup exposing (Model)
import String


type alias Model =
    { teams : Zipper RankedTeam
    , isShowingInfo : Bool
    , pageIndex : Int
    , ranking : RemoteData.RemoteData Http.Error TeamRankings
    }


type Msg
    = NextPage
    | OpenInfo
    | GotRanking (RemoteData.RemoteData Http.Error TeamRankings)


rankingDisplay : RemoteData.RemoteData Http.Error TeamRankings -> TeamRankings
rankingDisplay rank =
    case rank of
        RemoteData.Success validRanking ->
            validRanking

        RemoteData.Loading ->
            [ { name = "Loding...", position = 0 } ]

        _ ->
            let
                _ =
                    Debug.log "didn't succeed"
            in
            [ { name = "error", position = 0 } ]


createZipper : RemoteData.RemoteData Http.Error TeamRankings -> Zipper RankedTeam
createZipper rank =
    fromCons { name = "Open", position = 0 } <| rankingDisplay rank


moveZipperBy : Int -> Zipper a -> Zipper a
moveZipperBy moveBy zipper =
    if moveBy == 0 || isLast zipper then
        zipper

    else
        moveZipperBy (moveBy - 1) <| withDefault (current zipper) <| next zipper


arrangeThePage : List Team -> Element.Element Msg
arrangeThePage listOfTeams =
    table []
        { data = listOfTeams
        , columns =
            [ { header = text ""
              , width = fill
              , view =
                    \buttonMsg ->
                        button []
                            { onPress = Just OpenInfo
                            , label = text ">"
                            }
              }
            , { header = text "Name"
              , width = fill
              , view =
                    Element.text << String.fromInt << .name
              }
            , { header = text "Position"
              , width = fill
              , view =
                    Element.text << String.fromInt .position
              }
            ]
        }


getNeededList : Int -> Zipper a -> List a
getNeededList neededInPage zipper =
    List.take neededInPage <| current zipper :: after zipper


rankingParser : JD.Decoder TeamRankings
rankingParser =
    JD.map2 RankedTeam (JD.field "team_key" JD.string) (JD.field "rank" JD.int)
        |> JD.list
        |> JD.field "rankings"


init : RemoteData.RemoteData Http.Error TeamRankings -> ( Model, Cmd Msg )
init rankings =
    let
        inPageUp =
            min 3 << List.length << toList <| createZipper rankings
    in
    ( { teams = createZipper rankings, isShowingInfo = False, pageIndex = inPageUp, ranking = RemoteData.Loading }
    , Http.get
        { url = "http://localhost:1690/TBA"
        , expect = Http.expectJson (GotRanking << RemoteData.fromResult) rankingParser
        }
    )


view : Model -> Element.Element Msg
view model =
    let
        valid : Msg
        valid =
            case model.ranking of
                RemoteData.Success validRanking ->
                    NextPage

                RemoteData.Loading ->
                    GotRanking model.ranking

                _ ->
                    let
                        _ =
                            Debug.log "didn't succeed"
                    in
                    GotRanking model.ranking
    in
    column
        [ Background.color lightBlue
        , padding 10
        , spacing 10
        , width fill
        , height fill
        ]
        [ arrangeThePage <| getNeededList model.pageIndex model.teams
        , button
            [ Border.rounded 10
            , Background.gradient
                { angle = 2
                , steps = [ purple, orange, blueGreen ]
                }
            , width <| maximum 350 <| fill
            ]
            { onPress = Just valid
            , label = text "Next Page"
            }
        ]


update : Msg -> Model -> Model
update msg model =
    let
        pageIndex : Int
        pageIndex =
            min 3 <| List.length <| toList model.teams
    in
    case msg of
        NextPage ->
            { model | teams = moveZipperBy pageIndex model.teams, pageIndex = pageIndex }

        OpenInfo ->
            if model.isShowingInfo then
                { model | isShowingInfo = False }

            else
                { model | isShowingInfo = True }

        GotRanking valid ->
            { model | teams = createZipper valid }
