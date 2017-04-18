module View exposing (view)

import Html exposing (div, Html)
import Html.Attributes exposing (class)
import Models exposing (Model)
import Msgs exposing (Msg)
import Timer.View as Timer
import Todo.View as Todo


view : Model -> Html Msg
view model =
    div
        [ class "container" ]
        [ div
            [ class "row" ]
            [ div
                [ class "eight columns offset-by-two" ]
                [ Html.map Msgs.Todo (Todo.addTodo model)
                , Html.map Msgs.Timer (Timer.view model)
                , Html.map Msgs.Todo (Todo.todoList model.todos)
                , Html.map Msgs.Todo (Todo.confirmDeleteModal model)
                ]
            ]
        ]
