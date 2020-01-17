module Ranking exposing (Model, Msg, init, update, view)

import Browser
import Colors exposing (blueGreen, lightBlue, orange, purple)
import Element exposing (centerX, centerY, column, fill, height, html, layout, maximum, padding, rgb255, shrink, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (center)
import Element.Input as Input exposing (button)
import List.Zipper exposing (Zipper, after, current, fromCons, isLast, next, toList, withDefault)
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
        _ =
            Debug.log "Teams" (String.concat <| List.map teamToString <| getNeededList 4 createZipper)

        inPageUp =
            min 2 <| List.length <| toList createZipper
    in
    { teams = createZipper, isShowingInfo = False, inPage = inPageUp }


view : Model -> Element.Element Msg
view model =
    let
        _ =
            Debug.log "Teams" (String.concat <| List.map teamToString <| getNeededList model.inPage model.teams)

        _ =
            Debug.log "get needed list" (getNeededList model.inPage model.teams)
    in
    column
        [ centerX ]
        [ text <| String.concat <| List.map teamToString <| getNeededList model.inPage model.teams
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

        _ =
            Debug.log "in page" inPage

        _ =
            Debug.log "zipper" (moveZipperBy inPage model.teams)
    in
    case msg of
        NextPage ->
            { model | teams = moveZipperBy inPage model.teams, inPage = inPage }
