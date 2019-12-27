module Ranking exposing (init, update, view, Msg, Model)

import Browser
import Html exposing (Html)
import Html.Events as Events
import Lazy.Tree as Tree exposing (Tree(..))
import Lazy.Tree.Zipper as Zipper exposing (Zipper)


type alias Item =
    { id : Int
    , name : String
    , parent : Maybe Int
    }


items : List Item
items =
    [ { id = 1, name = "orbit", parent = Nothing }
    , { id = 2, name = "Banana", parent = Nothing }
    , { id = 3, name = "Baz", parent = Nothing }
    , { id = 4, name = "Bar", parent = Nothing }
    , { id = 5, name = "Foobar", parent = Just 1 }
    , { id = 6, name = "Bar child", parent = Just 2 }
    , { id = 7, name = "Foobar child", parent = Just 3 }
    , { id = 8, name = "Foobar child", parent = Just 4 }
    ]


{-| Zipper of pair where first value means `isOpen` and second contain Item details.
-}
type alias Model =
    Zipper ( Bool, Item )


init : String -> Model
init title =
    let
        root1 =
            { id = 1, name = title, parent = Nothing }
    in
    List.map (\b -> ( False, b )) items
        |> Tree.fromList (\p ( _, i ) -> Maybe.map (.id << Tuple.second) p == i.parent)
        |> Tree ( True, root1)
        |> Zipper.fromTree



-- Update


type Msg
    = Toggle (Zipper ( Bool, Item ))


update : Msg -> Model -> Model
update (Toggle zipper) _ =
    Zipper.updateItem (\( s, i ) -> ( not s, i )) zipper



-- View


view : Model -> Html Msg
view zipper =

    Html.ul [] [ viewLevel (Zipper.root zipper) ]


viewLevel : Zipper ( Bool, Item ) -> Html Msg
viewLevel zipper =
    let
        ( isOpen, item ) =
            Zipper.current zipper
    in
    Html.li []
        [ Html.a [ Events.onClick <| Toggle zipper ]
            [ if not (Zipper.isEmpty zipper) then
                Html.span []
                    [ if isOpen then
                        Html.text "- "

                      else
                        Html.text "+ "
                    ]

              else
                Html.text ""
            , Html.text item.name
            ]
        , Html.ul [] <|
            if isOpen then
                Zipper.openAll zipper
                    |> List.map viewLevel

            else
                []
        ]