module Timer.Update exposing (update)

import Models exposing (Model)
import Timer.Models exposing (..)
import Timer.Msgs exposing (TimerMsg)


update : TimerMsg -> Model -> Model
update msg model =
    case msg of
        Timer.Msgs.SetTimer ->
            { model | showSetTimer = True }

        Timer.Msgs.TimerInput text ->
            { model
                | transientTimer =
                    if (validateTimerInput text) then
                        text
                    else
                        model.transientTimer
            }

        Timer.Msgs.ConfirmSetTimer ->
            { model
                | timer =
                    Result.withDefault
                        5
                        (String.toInt model.transientTimer)
                        |> (*) 60
                , showSetTimer = False
            }

        Timer.Msgs.CancelSetTimer ->
            { model
                | showSetTimer = False
                , transientTimer =
                    toFloat model.timer / 60 |> toString
            }

        Timer.Msgs.StartTimer ->
            { model | timerState = Started }

        Timer.Msgs.PauseTimer ->
            { model | timerState = Paused }

        Timer.Msgs.ResetTimer ->
            { model
                | timer =
                    Result.withDefault
                        5
                        (String.toInt model.transientTimer)
                        |> (*) 60
                , timerState = Started
            }

        Timer.Msgs.StopTimer ->
            { model
                | timerState = Stopped
                , timer =
                    Result.withDefault
                        5
                        (String.toInt model.transientTimer)
                        |> (*) 60
            }

        Timer.Msgs.Tick time ->
            let
                timer =
                    updateTimer model
            in
                { model
                    | timer = timer
                    , timerState =
                        if timer == 0 then
                            Done
                        else
                            model.timerState
                }

        Timer.Msgs.NoOp ->
            model


updateTimer : Model -> Int
updateTimer model =
    if model.timer > 0 then
        case model.timerState of
            Started ->
                model.timer - 1

            _ ->
                model.timer
    else
        model.timer


validateTimerInput : String -> Bool
validateTimerInput timerInput =
    case (String.toInt timerInput) of
        Ok value ->
            value > 0

        Err error ->
            False
