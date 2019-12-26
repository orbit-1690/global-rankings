module Zipper exposing
    ( Zipper
    , getCurrent
    , getNext
    , getPrevious
    , makeZipper
    , moveBackwards
    , moveBackwardsTo
    , moveBackwardsWhile
    , moveForward
    , moveForwardTo
    , moveForwardWhile
    )

import List exposing (reverse)
import List.Extra exposing (init, last)
import Maybe exposing (andThen, withDefault)


type alias Zipper a =
    { previous : List a
    , current : a
    , next : List a
    }


makeZipper : List a -> a -> List a -> Zipper a
makeZipper previous current next =
    { previous = previous, current = current, next = next }


moveForward : Zipper a -> Maybe (Zipper a)
moveForward zipper =
    case init zipper.previous of
        Nothing ->
            Nothing

        Just choppedPrevious ->
            Just <|
                { previous = choppedPrevious
                , current = withDefault zipper.current <| last zipper.previous
                , next = zipper.current :: zipper.next
                }


moveBackwards : Zipper a -> Maybe (Zipper a)
moveBackwards zipper =
    moveForward << flipZipp <| zipper


flipZipp : Zipper a -> Zipper a
flipZipp zipper =
    { previous = reverse zipper.next
    , current = zipper.current
    , next = reverse zipper.previous
    }


moveForwardTo : a -> Zipper a -> Maybe (Zipper a)
moveForwardTo wantedCurrent zipper =
    if wantedCurrent == zipper.current then
        Just zipper

    else
        andThen (moveForwardTo wantedCurrent) <| moveForward zipper


moveBackwardsTo : a -> Zipper a -> Maybe (Zipper a)
moveBackwardsTo wantedCurrent zipper =
    if wantedCurrent == zipper.current then
        Just zipper

    else
        andThen (moveBackwardsTo wantedCurrent) <| moveBackwards zipper


moveForwardWhile : (a -> Bool) -> Zipper a -> Maybe (Zipper a)
moveForwardWhile ifCondition zipper =
    if ifCondition zipper.current then
        andThen (moveForwardWhile ifCondition) <| moveForward zipper

    else
        Just zipper


moveBackwardsWhile : (a -> Bool) -> Zipper a -> Maybe (Zipper a)
moveBackwardsWhile ifCondition zipper =
    if ifCondition zipper.current then
        andThen (moveBackwardsWhile ifCondition) <| moveBackwards zipper

    else
        Just zipper


getPrevious : Zipper a -> List a
getPrevious =
    .previous


getCurrent : Zipper a -> a
getCurrent =
    .current


getNext : Zipper a -> List a
getNext =
    .next
