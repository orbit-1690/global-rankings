<<<<<<< HEAD
module Setup exposing (Model, Msg, init, update, view)

import Debug exposing (todo)


type alias Model =
    { startYear : Int
    , endYear : Int
    , einsteinFactor : Float
    , districtFactor : Float
    , playOffFactor : Float
    , offSeasonFactor : Float
=======
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
>>>>>>> df0d69b585108131139b300fae8576701b43c60a
    }


type Msg
<<<<<<< HEAD
    = StartYear Int
    | EndYear Int
    | EinsteinFactor Int
=======
    = Slider1 Int
    | Slider2 Int
    | EinsteinFactor Float
>>>>>>> df0d69b585108131139b300fae8576701b43c60a
    | DistrictFactor Float
    | PlayOffFactor Float
    | OffSeasonFactor Float
    | Continue


<<<<<<< HEAD




module Ranking exposing (Model, init, Msg, view)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region


white =
    Element.rgb 1 1 1


grey =
    Element.rgb 0.9 0.9 0.9


blue =
    Element.rgb 0 0 0.8


red =
    Element.rgb 0.8 0 0


darkBlue =
    Element.rgb 0 0 0.9


=======
main : Program () Model Msg
>>>>>>> df0d69b585108131139b300fae8576701b43c60a
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


<<<<<<< HEAD
init =
    { username = ""
    , password = ""
    , agreeTOS = False
    , comment = "Extra hot sauce?\n\n\nYes pls"
    , lunch = Gyro
    , spiciness = 2
    }


type alias Model =
    { username : String
    , password : String
    , agreeTOS : Bool
    , comment : String
    , lunch : Lunch
    , spiciness : Float
    }


type Msg
    = Update Model


update msg model =
    case Debug.log "msg" msg of
        Update new ->
            new


type Lunch
    = Burrito
    | Taco
    | Gyro


view model =
    Element.layout
        [ Font.size 20
        ]
    <|
        Element.column [ width (px 800), height shrink, centerY, centerX, spacing 36, padding 10]
            [ el
                [ Region.heading 1
                , alignLeft
                , Font.size 36
                ]
                (text "Welcome to the Stylish Elephants Lunch Emporium")
            , Input.radio
                [ spacing 12
                , Background.color grey
                ]
                { selected = Just model.lunch
                , onChange = \new -> Update { model | lunch = new }
                , label = Input.labelAbove [ Font.size 14, paddingXY 0 12 ] (text "What would you like for lunch?")
                , options =
                    [ Input.option Gyro (text "Gyro")
                    , Input.option Burrito (text "Burrito")
                    , Input.option Taco (text "Taco")
                    ]
                }
            , Input.username
                [ spacing 12
                , below
                    (el
                        [ Font.color red
                        , Font.size 14
                        , alignRight
                        , moveDown 6
                        ]
                        (text "This one is wrong")
                    )
                ]
                { text = model.username
                , placeholder = Just (Input.placeholder [] (text "username"))
                , onChange = \new -> Update { model | username = new }
                , label = Input.labelAbove [ Font.size 14 ] (text "Username")
                }
            , Input.currentPassword [ spacing 12, width shrink ]
                { text = model.password
                , placeholder = Nothing
                , onChange = \new -> Update { model | password = new }
                , label = Input.labelAbove [ Font.size 14 ] (text "Password")
                , show = False
                }
            , Input.multiline
                [ height shrink
                , spacing 12

                -- , padding 6
                ]
                { text = model.comment
                , placeholder = Just (Input.placeholder [] (text "Extra hot sauce?\n\n\nYes pls"))
                , onChange = \new -> Update { model | comment = new }
                , label = Input.labelAbove [ Font.size 14 ] (text "Leave a comment!")
                , spellcheck = False
                }
            , Input.checkbox []
                { checked = model.agreeTOS
                , onChange = \new -> Update { model | agreeTOS = new }
                , icon = Input.defaultCheckbox
                , label = Input.labelRight [] (text "Agree to Terms of Service")
                }
            , Input.slider
                [ Element.height (Element.px 30)
                , Element.behindContent
                    (Element.el
                        [ Element.width Element.fill
                        , Element.height (Element.px 2)
                        , Element.centerY
                        , Background.color grey
                        , Border.rounded 2
                        ]
                        Element.none
                    )
                ]
                { onChange = \new -> Update { model | spiciness = new }
                , label = Input.labelAbove [] (text ("Spiciness: " ++ String.fromFloat model.spiciness))
                , min = 0
                , max = 3.2
                , step = Nothing
                , value = model.spiciness
                , thumb =
                    Input.defaultThumb
                }
            , Input.slider
                [ Element.width (Element.px 40)
                , Element.height (Element.px 200)
                , Element.behindContent
                    (Element.el
                        [ Element.height Element.fill
                        , Element.width (Element.px 2)
                        , Element.centerX
                        , Background.color grey
                        , Border.rounded 2
                        ]
                        Element.none
                    )
                ]
                { onChange = \new -> Update { model | spiciness = new }
                , label = Input.labelAbove [] (text ("Spiciness: " ++ String.fromFloat model.spiciness))
                , min = 0
                , max = 3.2
                , step = Nothing
                , value = model.spiciness
                , thumb =
                    Input.defaultThumb
                }
            , Input.button
                [ Background.color blue
                , Font.color white
                , Border.color darkBlue
                , paddingXY 32 16
                , Border.rounded 3
                , width fill
                ]
                { onPress = Nothing
                , label = Element.text "Place your lunch order!"
                }
            ]
=======
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
>>>>>>> df0d69b585108131139b300fae8576701b43c60a
