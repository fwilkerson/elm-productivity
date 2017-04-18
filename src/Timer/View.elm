module Timer.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (Model)
import Modal.Modal exposing (modal)
import Timer.Models exposing (..)
import Timer.Msgs exposing (..)


view : Model -> Html TimerMsg
view model =
    div
        [ class "row" ]
        [ setTimerModal model
        , div
            [ class "timer" ]
            (timer model)
        ]


setTimerModal : Model -> Html TimerMsg
setTimerModal model =
    let
        open =
            if model.showSetTimer then
                " modal-open"
            else
                ""
    in
        modal
            open
            ConfirmSetTimer
            CancelSetTimer
            [ h4 [] [ text "Set Timer" ]
            , h5 [ class "set-timer" ] [ text "How many minutes?" ]
            , input
                [ class "set-timer"
                , onInput TimerInput
                , type_ "number"
                , value model.transientTimer
                ]
                []
            ]


timer : Model -> List (Html TimerMsg)
timer model =
    case model.timerState of
        Started ->
            [ timerButton PauseTimer False (timerText model.timer False)
            , timerButton StopTimer True [ text "Stop" ]
            ]

        Paused ->
            [ timerButton StartTimer False (timerText model.timer True)
            , timerButton StopTimer True [ text "Stop" ]
            ]

        Done ->
            [ timerButton NoOp False (timerText model.timer True)
            , timerButton ResetTimer True [ text "Reset" ]
            ]

        Stopped ->
            [ timerButton SetTimer False [ text "Set Timer" ]
            , timerButton StartTimer True [ text "Start" ]
            ]


timerButton : TimerMsg -> Bool -> List (Html TimerMsg) -> Html TimerMsg
timerButton msg primary =
    let
        btnStyle =
            if primary then
                "button-primary"
            else
                "button"
    in
        button [ class btnStyle, onClick msg ]


timerText : Int -> Bool -> List (Html TimerMsg)
timerText timer paused =
    let
        classes =
            if paused then
                "countdown-text paused"
            else
                "countdown-text"
    in
        [ h5
            [ class classes ]
            [ timer |> timerToString |> text ]
        ]


timerToString : Int -> String
timerToString timer =
    minutes timer ++ ":" ++ seconds timer


minutes : Int -> String
minutes timer =
    if timer % 60 == 0 then
        toFloat timer / 60 |> toString
    else
        toFloat timer / 60 |> floor |> toString


seconds : Int -> String
seconds timer =
    if timer % 60 < 10 then
        timer % 60 |> toString |> (++) "0"
    else
        timer % 60 |> toString
