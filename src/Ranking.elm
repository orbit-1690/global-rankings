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
    , inPage : Int
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


arrangementThePage : List RankedTeam -> Element.Element Msg
arrangementThePage listOfTeams =
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
                    \team ->
                        text team.name
              }
            , { header = text "Position"
              , width = fill
              , view =
                    \team ->
                        text <| String.fromInt team.position
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
    ( { teams = createZipper rankings, isShowingInfo = False, inPage = inPageUp, ranking = RemoteData.Loading }
    , Http.get
        { url = "http://localhost:1690/TBA"
        , expect = Http.expectJson (GotRanking << RemoteData.fromResult) rankingParser
        }
    )


view : Model -> Element.Element Msg
view model =
    case model.ranking of
        RemoteData.Success _ ->
            column
                [ centerX ]
                [ arrangementThePage <| getNeededList 3 model.teams
                , button
                    [ Border.rounded 10
                    , Background.gradient
                        { angle = 2
                        , steps = [ purple, orange, blueGreen ]
                        }
                    , width <| maximum 350 <| fill
                    ]
                    { onPress = Just NextPage
                    , label = text "Next Page"
                    }
                ]

        RemoteData.Loading ->
            text "Loading..."

        _ ->
            text "error"


update : Msg -> Model -> Model
update msg model =
    let
        inPage : Int
        inPage =
            min 3 (List.length <| toList model.teams)
    in
    case msg of
        NextPage ->
            { model | teams = moveZipperBy inPage model.teams, inPage = inPage }

        OpenInfo ->
            if model.isShowingInfo then
                { model | isShowingInfo = False }

            else
                { model | isShowingInfo = True }

        GotRanking valid ->
            { model | ranking = valid, teams = createZipper valid }
