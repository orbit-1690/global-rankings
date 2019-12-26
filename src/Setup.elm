module Setup exposing (Model)

import Browser
import Element exposing (Element, el, px, rgb255, text)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html


type alias Model =
    { startYear : Int
    , endYear : Int
    , einsteinFactor : Float
    , districtFactor : Float
    , playOffFactor : Float
    , offSeasonFactor : Float
    }


type Msg
    = StartYear Int
    | EndYear Int
    | EinsteinFactor Float
    | DistrictFactor Float
    | PlayOffFactor Float
    | OffSeasonFactor Float
    | Continue


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


init : Model
init =
    { startYear = 2017
    , endYear = 2019
    , einsteinFactor = 1
    , districtFactor = 1
    , playOffFactor = 1
    , offSeasonFactor = 1
    }


stringToFloat : String -> Float
stringToFloat number =
    let
        maybeFloat =
            String.toFloat number
    in
    case maybeFloat of
        Nothing ->
            0

        Just value ->
            value


yearsInput : Int -> Input.Label Msg -> (Float -> Msg) -> Element Msg
yearsInput value label onChange =
    el [ Element.centerX, Element.width <| px 345 ] <|
        Input.slider
            [ Element.height (Element.px 20)
            , Element.behindContent
                (Element.el
                    [ Element.width Element.fill
                    , Element.height (Element.px 6)
                    , Element.centerY
                    , Background.color <| rgb255 0 0 200
                    , Border.rounded 4
                    , Element.centerX
                    ]
                    Element.none
                )
            ]
            { onChange = onChange
            , label = label
            , min = 2007
            , max = 2019
            , step = Just 1
            , value = toFloat value
            , thumb =
                Input.defaultThumb
            }


factorInput : Float -> String -> (String -> Msg) -> Element Msg
factorInput value labelText sendMsg =
    el [ Element.alignRight, Element.width <| px 317 ] <|
        Input.text [ Element.width <| px 60, Font.size 20 ]
            { onChange = sendMsg
            , placeholder = Nothing
            , text = String.fromFloat value
            , label = Input.labelLeft [ Element.centerY, Element.centerX, Font.size 30 ] <| Element.text labelText
            }


continueButton : Element Msg
continueButton =
    el [ Element.centerX, Element.centerY ] <|
        Input.button
            [ Background.color <| Element.rgb255 255 255 255
            , Border.rounded 7
            , Font.size 30
            , Font.color <| Element.rgb255 0 0 200
            , Border.width 4
            ]
            { onPress = Just Continue
            , label = text "Continue"
            }


update : Msg -> Model -> Model
update msg model =
    case msg of
        EinsteinFactor value ->
            { model | einsteinFactor = value }

        StartYear value ->
            { model | startYear = value }

        EndYear value ->
            { model | endYear = value }

        DistrictFactor value ->
            { model | districtFactor = value }

        PlayOffFactor value ->
            { model | playOffFactor = value }

        OffSeasonFactor value ->
            { model | offSeasonFactor = value }

        default ->
            model


view : Model -> Html.Html Msg
view model =
    Element.layout [] <|
        Element.column [ Element.centerX, Element.moveDown 200, Element.scale 1.9 ]
            [ yearsInput
                model.startYear
                (Input.labelAbove [ Font.color <| rgb255 0 0 200, Font.size 43, Element.centerX ] (text "Years:"))
                (\number -> StartYear <| round number)
            , yearsInput
                model.endYear
                (Input.labelBelow [ Font.color <| rgb255 0 0 200, Font.size 40, Element.alignLeft ]
                    (text <| "From " ++ String.fromInt model.startYear ++ " To " ++ String.fromInt model.endYear)
                )
                (\number -> EndYear <| round number)
            , Element.column [ Element.centerX, Element.scale 1.1, Element.moveDown 25 ]
                [ factorInput model.districtFactor "District Factor:       " (\number -> DistrictFactor <| stringToFloat number)
                , factorInput model.offSeasonFactor "Off Season Factor:" (\number -> OffSeasonFactor <| stringToFloat number)
                , factorInput model.playOffFactor "PlayOff Factor:      " (\number -> PlayOffFactor <| stringToFloat number)
                , factorInput model.einsteinFactor "Einstein Factor:     " (\number -> EinsteinFactor <| stringToFloat number)
                , continueButton
                ]
            ]
