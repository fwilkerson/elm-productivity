module Update exposing (update)

import Models exposing (Model)
import Msgs exposing (Msg)
import Todo.Update as Todo
import Timer.Update as Timer


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.Timer timerMsg ->
            ( (Timer.update timerMsg model), Cmd.none )

        Msgs.Todo todoMsg ->
            ( (Todo.update todoMsg model), Cmd.none )
