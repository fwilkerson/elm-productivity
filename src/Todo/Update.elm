module Todo.Update exposing (update)

import Models exposing (Model)
import Todo.Models exposing (Todo)
import Todo.Msgs exposing (TodoMsg)


update : TodoMsg -> Model -> Model
update msg model =
    case msg of
        Todo.Msgs.TodoInput text ->
            { model | text = text }

        Todo.Msgs.AddTodo ->
            { model
                | todos = addTodo model
                , text = ""
                , todoIdenity = model.todoIdenity + 1
            }

        Todo.Msgs.Complete todoId ->
            { model
                | todos =
                    List.map (completeTodo todoId) model.todos
            }

        Todo.Msgs.Remove todoId ->
            { model | deleteId = Just todoId }

        Todo.Msgs.ConfirmRemove ->
            { model
                | todos =
                    let
                        deleteId =
                            Maybe.withDefault -1 model.deleteId
                    in
                        List.filter (\todo -> todo.id /= deleteId) model.todos
                , deleteId = Nothing
            }

        Todo.Msgs.CancelRemove ->
            { model | deleteId = Nothing }


addTodo : Model -> List Todo
addTodo model =
    let
        todo =
            { id = model.todoIdenity
            , completed = False
            , text = model.text
            }
    in
        todo :: model.todos


completeTodo : Int -> Todo -> Todo
completeTodo todoId todo =
    if todoId == todo.id then
        { todo | completed = not todo.completed }
    else
        todo
