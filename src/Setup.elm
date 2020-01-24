module Setup exposing (Model, Msg, init, main, update, view)

import Element exposing (Element, column, el, px, rgb255, text)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input


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
    | EinsteinFactor String
    | DistrictFactor String
    | PlayOffFactor String
    | OffSeasonFactor String
    | Continue


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = Element.layout [] << view
        , update = update
        }


init : Float -> Float -> Float -> Float -> Int -> Int -> Model
init =
    Model


stringToFloat : String -> Float
stringToFloat =
    Maybe.withDefault 0 << String.toFloat


yearsInput : Int -> Input.Label Msg -> (Float -> Msg) -> Element Msg
yearsInput value label onChange =
    Input.slider
        [ Element.height <| Element.px 20
        , Element.behindContent <|
            Element.el
                [ Element.width Element.fill
                , Element.height <| Element.px 6
                , Element.centerY
                , Background.color <| rgb255 0 0 200
                , Border.rounded 4
                , Element.centerX
                ]
                Element.none
        ]
        { onChange = onChange
        , label = label
        , min = 2007
        , max = 2020
        , step = Just 1
        , value = toFloat value
        , thumb =
            Input.defaultThumb
        }
        |> el [ Element.centerX, Element.width <| px 345 ]


factorInput : Float -> String -> (String -> Msg) -> Element Msg
factorInput value labelText sendMsg =
    Input.text [ Element.width <| px 60, Font.size 20 ]
        { onChange = sendMsg
        , placeholder = Nothing
        , text = String.fromFloat value
        , label = Input.labelLeft [ Element.centerY, Element.centerX, Font.size 30 ] <| Element.text labelText
        }
        |> el [ Element.alignRight, Element.width <| px 317 ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        EinsteinFactor value ->
            { model | einsteinFactor = stringToFloat value }

        Slider1 value ->
            { model | slider1 = value }

        Slider2 value ->
            { model | slider2 = value }

        DistrictFactor value ->
            { model | districtFactor = stringToFloat value }

        PlayOffFactor value ->
            { model | playOffFactor = stringToFloat value }

        OffSeasonFactor value ->
            { model | offSeasonFactor = stringToFloat value }


view : Model -> Element.Element Msg
view model =
    let
        endYear : Int
        endYear =
            max model.slider1 model.slider2

        startYear : Int
        startYear =
            min model.slider1 model.slider2
    in
    column [ Element.centerX, Element.moveDown 200, Element.scale 1.9 ]
        [ yearsInput
            model.slider1
            (Input.labelAbove [ Font.color <| rgb255 0 0 200, Font.size 43, Element.centerX ] <| text "Years:")
            (Slider1 << round)
        , yearsInput
            model.slider2
            (Input.labelBelow [ Font.color <| rgb255 0 0 200, Font.size 40, Element.alignLeft ]
                (text <| "From " ++ String.fromInt startYear ++ " To " ++ String.fromInt endYear)
            )
            (Slider2 << round)
        , column [ Element.centerY, Element.centerX, Element.scale 1.1, Element.moveDown 25 ]
            [ factorInput model.districtFactor "District Factor:       " DistrictFactor
            , factorInput model.offSeasonFactor "Off Season Factor:" OffSeasonFactor
            , factorInput model.playOffFactor "PlayOff Factor:      " PlayOffFactor
            , factorInput model.einsteinFactor "Einstein Factor:     " EinsteinFactor
            , continueButton
            ]
        ]
