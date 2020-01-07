module Setup exposing (Model)

import Browser
import Element exposing (Element, el, px, rgb255, text)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html


type alias Model =
    { einsteinFactor : Float
    , districtFactor : Float
    , playOffFactor : Float
    , offSeasonFactor : Float
    , slider1 : Int
    , slider2 : Int
    }


type Msg
    = Slider1 Int
    | Slider2 Int
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
    { einsteinFactor = 1
    , districtFactor = 1
    , playOffFactor = 1
    , offSeasonFactor = 1
    , slider1 = 2017
    , slider2 = 2019
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


biggerYear : Int -> Int -> Int
biggerYear slider1 slider2 =
    if slider1 > slider2 then
        slider1

    else
        slider2


smallerYear : Int -> Int -> Int
smallerYear slider1 slider2 =
    if slider1 > slider2 then
        slider2

    else
        slider1


update : Msg -> Model -> Model
update msg model =
    case msg of
        EinsteinFactor value ->
            { model | einsteinFactor = value }

        Slider1 value ->
            { model | slider1 = value }

        Slider2 value ->
            { model | slider2 = value }

        DistrictFactor value ->
            { model | districtFactor = value }

        PlayOffFactor value ->
            { model | playOffFactor = value }

        OffSeasonFactor value ->
            { model | offSeasonFactor = value }

        Continue ->
            model


view : Model -> Html.Html Msg
view model =
    let
        endYear =
            biggerYear model.slider1 model.slider2

        startYear =
            smallerYear model.slider1 model.slider2
    in
    Element.layout [] <|
        Element.column [ Element.centerX, Element.moveDown 200, Element.scale 1.9 ]
            [ yearsInput
                model.slider1
                (Input.labelAbove [ Font.color <| rgb255 0 0 200, Font.size 43, Element.centerX ] (text "Years:"))
                (\number -> Slider1 <| round number)
            , yearsInput
                model.slider2
                (Input.labelBelow [ Font.color <| rgb255 0 0 200, Font.size 40, Element.alignLeft ]
                    (text <| "From " ++ String.fromInt startYear ++ " To " ++ String.fromInt endYear)
                )
                (\number -> Slider2 <| round number)
            , Element.column [ Element.centerX, Element.scale 1.1, Element.moveDown 25 ]
                [ factorInput model.districtFactor "District Factor:       " (\number -> DistrictFactor <| stringToFloat number)
                , factorInput model.offSeasonFactor "Off Season Factor:" (\number -> OffSeasonFactor <| stringToFloat number)
                , factorInput model.playOffFactor "PlayOff Factor:      " (\number -> PlayOffFactor <| stringToFloat number)
                , factorInput model.einsteinFactor "Einstein Factor:     " (\number -> EinsteinFactor <| stringToFloat number)
                , continueButton
                ]
            ]

