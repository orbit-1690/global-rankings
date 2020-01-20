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
            [ { header = Element.text "Number"
              , width = fill
              , view =
                    \team ->
                        Element.text <| String.fromInt team.number
              }
            , { header = Element.text "Score"
              , width = fill
              , view =
                    \team ->
                        Element.text <| String.fromInt team.score
              }
            , { header = Element.text "Name"
              , width = fill
              , view =
                    \team ->
                        Element.text team.name
              }
            ]
        }


getNeededList : Int -> Zipper a -> List a
getNeededList neededInPage zipper =
    List.take neededInPage <| current zipper :: after zipper


teamToString : Team -> String
teamToString team =
    String.fromInt team.number
        ++ " "
        ++ team.name
        ++ " "
        ++ String.fromInt team.score


init : Model
init =
    let
        inPageUp =
            min 2 <| List.length <| toList createZipper
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
            , width <| maximum 350 <| fill
            ]
            { onPress = Just NextPage
            , label = Element.text "Next Page"
            }
        ]


update : Msg -> Model -> Model
update msg model =
    let
        inPage : Int
        inPage =
            min 2 (List.length <| toList model.teams)
    in
    case msg of
        NextPage ->
            { model | teams = moveZipperBy inPage model.teams, inPage = inPage }
