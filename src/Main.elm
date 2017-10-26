module Main exposing (main)

import Html exposing (div, Html, program)
import Html.Attributes exposing (class)
import Time exposing (every, second)
import Components.Timer
import Components.Todo


-- Model --


type alias Model =
    { timer : Components.Timer.Model
    , todo : Components.Todo.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { timer = Components.Timer.initialModel
      , todo = Components.Todo.initialModel
      }
    , Cmd.none
    )



-- Update --


type Msg
    = Timer Components.Timer.Msg
    | Todo Components.Todo.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Timer timerMsg ->
            let
                ( subModel, subCmd ) =
                    Components.Timer.update timerMsg model.timer
            in
                ( { model | timer = subModel }, Cmd.map Timer subCmd )

        Todo todoMsg ->
            let
                ( subModel, subCmd ) =
                    Components.Todo.update todoMsg model.todo
            in
                ( { model | todo = subModel }, Cmd.map Todo subCmd )



-- Subscriptions --


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map Timer (every second Components.Timer.Tick)



-- View --


view : Model -> Html Msg
view model =
    div
        [ class "container" ]
        [ div
            [ class "row" ]
            [ div
                [ class "eight columns offset-by-two" ]
                [ Html.map Todo (Components.Todo.todoInput model.todo)
                , Html.map Timer (Components.Timer.view model.timer)
                , Html.map Todo (Components.Todo.todoList model.todo)
                ]
            ]
        ]



-- Main --


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
