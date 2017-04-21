module Todo.View exposing (addTodo, todoList, confirmDeleteModal)

import Html exposing (div, h4, h6, Html, input, li, p, span, text, ul)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Maybe exposing (withDefault)
import Models exposing (Model)
import Common.Modal exposing (modal)
import Todo.Models exposing (Todo)
import Todo.Msgs exposing (..)


addTodo : Model -> Html TodoMsg
addTodo model =
    div
        [ class "row" ]
        [ Html.form
            [ onSubmit AddTodo ]
            [ input
                [ type_ "text"
                , onInput TodoInput
                , placeholder "What needs to be done?"
                , value model.text
                , class "add-todo u-full-width"
                , autofocus True
                ]
                []
            ]
        ]


todoList : List Todo -> Html TodoMsg
todoList todos =
    ul [ class "fa-ul" ]
        (List.map todoItem todos)


todoItem : Todo -> Html TodoMsg
todoItem todo =
    li
        [ class "fa-li-custom" ]
        [ span
            [ class "fa-li fa fa-trash-o"
            , onClick (Remove todo.id)
            ]
            []
        , p
            [ style (todoItemStyle todo)
            , onClick (Complete todo.id)
            ]
            [ text todo.text ]
        ]


todoItemStyle : Todo -> List ( String, String )
todoItemStyle todo =
    let
        styles =
            [ ( "cursor", "pointer" )
            , ( "display", "inline" )
            ]
    in
        if todo.completed then
            ( "text-decoration", "line-through" ) :: styles
        else
            styles


confirmDeleteModal : Model -> Html TodoMsg
confirmDeleteModal model =
    let
        deleting =
            getTodoById (withDefault -1 model.deleteId) model.todos

        ( content, open ) =
            case deleting of
                Just todo ->
                    ( todo.text, True )

                Nothing ->
                    ( "", False )
    in
        modal
            open
            ConfirmRemove
            CancelRemove
            [ h4 [] [ text "Delete Todo?" ]
            , h6 [] [ text content ]
            ]


getTodoById : Int -> List Todo -> Maybe Todo
getTodoById todoId todos =
    List.filter (\todo -> todo.id == todoId) todos |> List.head
