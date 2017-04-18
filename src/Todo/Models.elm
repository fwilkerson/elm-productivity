module Todo.Models exposing (Todo)


type alias Todo =
    { id : Int
    , completed : Bool
    , text : String
    }
