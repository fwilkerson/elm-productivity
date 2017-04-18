module Todo.Msgs exposing (TodoMsg(..))


type TodoMsg
    = TodoInput String
    | AddTodo
    | Complete Int
    | Remove Int
    | ConfirmRemove
    | CancelRemove
