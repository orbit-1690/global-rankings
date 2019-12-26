module Zipper exposing
    ( Zipper
    , getCurrent
    , makeZipper
    , moveBackwards
    , moveBackwardsTo
    , moveBackwardsWhile
    , moveForward
    , moveForwardTo
    , moveForwardWhile
    )

import Debug
import List exposing (append, head, isEmpty, tail)
import List.Extra exposing (dropWhile, dropWhileRight, find, init, last, takeWhile, takeWhileRight)
import Maybe exposing (withDefault)


type alias Zipper a =
    { previous : List a
    , current : a
    , next : List a
    }


makeZipper : List a -> a -> List a -> Maybe (Zipper a)
makeZipper previous current next =
    if Just current == Nothing then
        Nothing

    else
        Just { previous = previous, current = current, next = next }


moveForward : Zipper a -> Zipper a
moveForward zipper =
    if isEmpty zipper.previous then
        --TODO: figure out whether it should actually be returning "Nothing"
        zipper

    else
        { previous = withDefault [] <| init zipper.previous
        , current = withDefault zipper.current <| last zipper.previous
        , next = zipper.current :: zipper.next
        }


moveBackwards : Zipper a -> Zipper a
moveBackwards zipper =
    if isEmpty zipper.next then
        --TODO: figure out whether it should actually be returning "Nothing"
        zipper

    else
        { previous = append zipper.previous [ zipper.current ]
        , current = withDefault zipper.current <| head zipper.next
        , next = withDefault [] <| tail zipper.next
        }


moveForwardTo : a -> Zipper a -> Maybe (Zipper a)
moveForwardTo =
    Debug.todo "make moveForwardTo"


moveBackwardsTo : a -> Zipper a -> Maybe (Zipper a)
moveBackwardsTo =
    Debug.todo "make moveBackwardsTo"


moveForwardWhile : (a -> Bool) -> Zipper a -> Zipper a
moveForwardWhile ifCondition zipper =
    if ifCondition zipper.current then
        moveForwardWhile ifCondition << moveForward <| zipper

    else
        zipper


moveBackwardsWhile : (a -> Bool) -> Zipper a -> Zipper a
moveBackwardsWhile ifCondition zipper =
    if ifCondition zipper.current then
        moveBackwardsWhile ifCondition << moveBackwards <| zipper

    else
        zipper


getCurrent : Zipper a -> a
getCurrent zipper =
    zipper.current
