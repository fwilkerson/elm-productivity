module Models exposing (Model, initialModel)

import Timer.Models exposing (..)
import Todo.Models exposing (Todo)


type alias Model =
    { todos : List Todo
    , text : String
    , deleteId : Maybe Int
    , todoIdenity : Int
    , showSetTimer : Bool
    , transientTimer : String
    , timer : Int
    , timerState : TimerState
    }


initialModel : Model
initialModel =
    { todos =
        [ { id = 0
          , text = "Add alarm when timer completes"
          , completed = False
          }
        ]
    , text = ""
    , deleteId = Nothing
    , todoIdenity = 1
    , showSetTimer = False
    , transientTimer = "1"
    , timer = 60
    , timerState = Stopped
    }
