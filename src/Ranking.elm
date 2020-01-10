module Ranking exposing (Model, Msg, init, update, view)

import Browser
import Colors exposing (black, blue, blueGreen, lightBlue, orange, purple, sky, white)
import Element exposing (alignLeft, alignRight, centerX, centerY, column, el, fill, height, html, layout, maximum, padding, rgb255, shrink, spacing, table, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (center)
import Element.Input as Input exposing (button)
import List.Extra exposing (count, getAt, takeWhileRight)
import List.Zipper exposing (Zipper, after, current, isLast, next, toList, withDefault)
import Maybe
import SetZipper exposing (Team, createZipper)
import String


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view >> layout []
        , update = update
        }


type alias Model =
    { teams : Zipper Team
    , isShowingInfo : Bool
    , inPage : Int
    }


type Msg
    = NextPage
    | OpenInfo


moveZipperBy : Int -> Zipper a -> Zipper a
moveZipperBy moveBy zipper =
    if moveBy == 0 || isLast zipper then
        zipper

    else
        moveZipperBy (moveBy - 1) <| withDefault (current zipper) <| next zipper


arrangementThePage : List Team -> Element.Element Msg
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
            , { header = text "Number"
              , width = fill
              , view =
                    \team ->
                        text <| String.fromInt team.number
              }
            , { header = text "Score"
              , width = fill
              , view =
                    \team ->
                        text <| String.fromInt team.score
              }
            , { header = text "Name"
              , width = fill
              , view =
                    \team ->
                        text team.name
              }
            ]
        }


getNeededList : Int -> Zipper a -> List a
getNeededList neededInPage zipper =
    List.take neededInPage <| current zipper :: after zipper



init : Model
init =
    let
        inPageUp =
            min 3 <| List.length <| toList createZipper
    in
    { teams = createZipper, isShowingInfo = False, inPage = inPageUp }


view : Model -> Element.Element Msg
view model =
    column
        [ Background.color lightBlue
        , padding 10
        , spacing 10
        , width fill
        , height fill
        ]
        [ arrangementThePage <| getNeededList model.inPage model.teams
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
            { onPress = Just NextPage
            , label = text "Next Page"
            }
        ]


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
