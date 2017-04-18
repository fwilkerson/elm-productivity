module Modal.Modal exposing (modal)

import Html exposing (a, button, div, hr, Html, i, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


modal : String -> msg -> msg -> List (Html msg) -> Html msg
modal open ok cancel content =
    div
        [ class ("modal" ++ open) ]
        [ div
            [ class "modal-inner container" ]
            [ div
                [ class "modal-content eight columns offset-by-two" ]
                [ div
                    [ class "modal-close-icon" ]
                    [ a
                        [ onClick cancel ]
                        [ i [ class "fa fa-times" ] [] ]
                    ]
                , div [ class "modal-content-inner" ] content
                , hr [ class "modal-buttons-seperator" ] []
                , div
                    [ class "modal-buttons" ]
                    [ button
                        [ class "button"
                        , onClick cancel
                        ]
                        [ text "Cancel" ]
                    , button
                        [ class "button button-primary"
                        , onClick ok
                        ]
                        [ text "Ok" ]
                    ]
                ]
            ]
        ]
