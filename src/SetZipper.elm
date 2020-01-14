module SetZipper exposing (Team, createZipper)

import List.Zipper exposing (Zipper, fromCons)


type alias Team =
    { number : Int
    , name : String
    , score : Int
    }


createZipper : Zipper Team
createZipper =
    fromCons { number = 1690, name = "Orbit", score = 50 }
        [ { number = 254, name = "Cheezy Poofs", score = 49 }
        , { number = 4319, name = "Ladies First", score = -10 }
        , { number = 42, name = "Fake", score = 42 }
        ]
