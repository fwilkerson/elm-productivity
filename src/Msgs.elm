module Msgs exposing (Msg(..))

import Timer.Msgs exposing (TimerMsg)
import Todo.Msgs exposing (TodoMsg)


type Msg
    = Timer TimerMsg
    | Todo TodoMsg
