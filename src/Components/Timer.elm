module Components.Timer exposing (initialModel, Model, Msg(Tick), update, view)

import Html exposing (button, div, h4, h5, Html, input, text)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onClick, onInput)
import Time exposing (Time)
import Components.Modal exposing (modal)


-- Model --


type TimerState
    = Started
    | Paused
    | Done
    | Stopped


type alias Model =
    { showSetTimer : Bool
    , transientTimer : String
    , timer : Int
    , timerState : TimerState
    }


initialModel : Model
initialModel =
    { showSetTimer = False
    , transientTimer = "1"
    , timer = 60
    , timerState = Stopped
    }



-- Update --


type Msg
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTimer ->
            ( { model | showSetTimer = True }, Cmd.none )

        TimerInput text ->
            ( { model
                | transientTimer =
                    if (validateTimerInput text) then
                        text
                    else
                        model.transientTimer
              }
            , Cmd.none
            )

        ConfirmSetTimer ->
            ( { model
                | timer =
                    Result.withDefault
                        5
                        (String.toInt model.transientTimer)
                        |> (*) 60
                , showSetTimer = False
              }
            , Cmd.none
            )

        CancelSetTimer ->
            ( { model
                | showSetTimer = False
                , transientTimer =
                    toFloat model.timer / 60 |> toString
              }
            , Cmd.none
            )

        StartTimer ->
            ( { model | timerState = Started }, Cmd.none )

        PauseTimer ->
            ( { model | timerState = Paused }, Cmd.none )

        ResetTimer ->
            ( { model
                | timer =
                    Result.withDefault
                        5
                        (String.toInt model.transientTimer)
                        |> (*) 60
                , timerState = Started
              }
            , Cmd.none
            )

        StopTimer ->
            ( { model
                | timerState = Stopped
                , timer =
                    Result.withDefault
                        5
                        (String.toInt model.transientTimer)
                        |> (*) 60
              }
            , Cmd.none
            )

        Tick time ->
            let
                timer =
                    updateTimer model
            in
                ( { model
                    | timer = timer
                    , timerState =
                        if timer == 0 then
                            Done
                        else
                            model.timerState
                  }
                , Cmd.none
                )

        NoOp ->
            ( model, Cmd.none )


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



-- View --


view : Model -> Html Msg
view model =
    div
        [ class "row" ]
        [ setTimerModal model
        , div
            [ class "timer" ]
            (timer model)
        ]


setTimerModal : Model -> Html Msg
setTimerModal model =
    let
        open =
            if model.showSetTimer then
                True
            else
                False
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


timer : Model -> List (Html Msg)
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


timerButton : Msg -> Bool -> List (Html Msg) -> Html Msg
timerButton msg primary =
    let
        btnStyle =
            if primary then
                "button-primary"
            else
                "button"
    in
        button [ class btnStyle, onClick msg ]


timerText : Int -> Bool -> List (Html Msg)
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
