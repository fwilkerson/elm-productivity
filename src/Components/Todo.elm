module Components.Todo exposing (initialModel, Model, Msg, todoInput, todoList, update)

import Html exposing (div, h4, h6, Html, input, li, p, span, text, ul)
import Html.Attributes exposing (autofocus, class, placeholder, style, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Maybe exposing (withDefault)
import Components.Modal exposing (modal)


-- Model --


type alias Todo =
    { id : Int
    , completed : Bool
    , text : String
    }


type alias Model =
    { todos : List Todo
    , text : String
    , deleteId : Maybe Int
    , todoIdenity : Int
    }


initialModel : Model
initialModel =
    { todos =
        [ { id = 0
          , text = "Add alarm when timer completes"
          , completed = False
          }
        ]
    , text = ""
    , deleteId = Nothing
    , todoIdenity = 1
    }



-- Update --


type Msg
    = TodoInput String
    | AddTodo
    | Complete Int
    | Remove Int
    | ConfirmRemove
    | CancelRemove


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TodoInput text ->
            ( { model | text = text }, Cmd.none )

        AddTodo ->
            ( { model
                | todos = addTodo model
                , text = ""
                , todoIdenity = model.todoIdenity + 1
              }
            , Cmd.none
            )

        Complete todoId ->
            ( { model
                | todos =
                    List.map (completeTodo todoId) model.todos
              }
            , Cmd.none
            )

        Remove todoId ->
            ( { model | deleteId = Just todoId }, Cmd.none )

        ConfirmRemove ->
            ( { model
                | todos =
                    let
                        deleteId =
                            Maybe.withDefault -1 model.deleteId
                    in
                        List.filter (\todo -> todo.id /= deleteId) model.todos
                , deleteId = Nothing
              }
            , Cmd.none
            )

        CancelRemove ->
            ( { model | deleteId = Nothing }, Cmd.none )


addTodo : Model -> List Todo
addTodo model =
    let
        todo =
            { id = model.todoIdenity
            , completed = False
            , text = model.text
            }
    in
        model.todos ++ [ todo ]


completeTodo : Int -> Todo -> Todo
completeTodo todoId todo =
    if todoId == todo.id then
        { todo | completed = not todo.completed }
    else
        todo



-- View --


todoInput : Model -> Html Msg
todoInput model =
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


todoList : Model -> Html Msg
todoList model =
    ul [ class "fa-ul" ]
        (confirmDeleteModal model
            :: (List.map todoItem model.todos)
        )


todoItem : Todo -> Html Msg
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


confirmDeleteModal : Model -> Html Msg
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
