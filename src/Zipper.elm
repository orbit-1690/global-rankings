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
import List.Extra as ListE
import Maybe exposing (withDefault)


type alias Zipper a =
    { previous : List a
    , current : a
    , next : List a
    }


makeZipper : List a -> a -> List a -> Maybe (Zipper a)
makeZipper previous current next =
    Just { previous = previous, current = current, next = next }


moveForward : Zipper a -> Maybe (Zipper a)
moveForward zipper =
    Just <|
        if isEmpty zipper.previous then
            --TODO: figure out whether it should actually be returning "Nothing"
            zipper

        else
            { previous = withDefault [] <| ListE.init zipper.previous
            , current = withDefault zipper.current <| ListE.last zipper.previous
            , next = zipper.current :: zipper.next
            }


moveBackwards : Zipper a -> Maybe (Zipper a)
moveBackwards zipper =
    Just <|
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


moveForwardWhile : (a -> Bool) -> Zipper a -> Maybe (Zipper a)
moveForwardWhile =
    Debug.todo "make moveForwardWhile"


moveBackwardsWhile : (a -> Bool) -> Zipper a -> Maybe (Zipper a)
moveBackwardsWhile =
    Debug.todo "make moveBackwardsWhile"


getCurrent : Zipper a -> a
getCurrent zipper =
    zipper.current
