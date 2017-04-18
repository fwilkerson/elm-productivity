module Timer.Msgs exposing (TimerMsg(..))

import Time exposing (Time)


type TimerMsg
    = SetTimer
    | TimerInput String
    | ConfirmSetTimer
    | CancelSetTimer
    | StartTimer
    | PauseTimer
    | ResetTimer
    | StopTimer
    | Tick Time
    | NoOp
