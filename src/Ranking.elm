module Ranking exposing (Model, Msg, init, update, view)

import Browser
import List.Zipper exposing (current, after)
import SetZipper exposing (crateZipper)
import Colors exposing (black, blue, blueGreen, lightBlue, orange, purple, sky, white)
import Element exposing (centerX, centerY, column, fill, height, html, layout, maximum, padding, rgb255, shrink, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (center)
import Element.Input as Input exposing (button)
import Maybe
import String


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view >> layout []
        , update = update
        }


type alias Model =
    { teams : Zipper (Zipper Team)
    , isShowingInfo : Bool -- What I need to do with this variable?
    , inPage : Int
    , windowHeight : Int
    }


type Msg
    = NextPage


type alias Team =
    { number : Int
    , name : String
    , score : Float
    }


moveZipperBy : Int -> Zipper a -> Zipper a -- Never failed
moveZipperBy moveBy zipper =
    let
        zipperNextCurrent : Maybe (Zipper a)
        zipperNextCurrent = next zipper
    in
        if moveBy == 0 || zipperNextCurrent == Nothing then
            zipper
        else
            next zipper
            moveZipperBy (moveBy - 1) zipper


getNeededList : Int -> Zipper a -> List a
getNeededList neededInPage zipper =
    List.take neededInPage <| (current zipper) :: after zipper


init : Flags -> Model
init flags =
    crateZipper False 0 flags.windowHeight


view : Model -> Element.Element Msg
view model =
    column
        [ Background.color lightBlue
        , padding 10
        , spacing 10
        , width fill
        , height fill
        ]
        [ text <| String.fromList <| getNeededList model.inPage model.teams -- show on screen
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
            , label = Element.text "Next Page"
            }
        ]

var app = Elm.Main.fullscreen({ windowHeight: window.innerHeight })


update : Msg -> Model -> Model
update msg model =
    model.inPage = mod (List.length <| toList model.teams) <| model.windowHeight * 0.25 -- Constant according to our needs
    case msg of
    NextPage ->
        { model | moveZipperBy inPage model }

        _ ->
            model
        