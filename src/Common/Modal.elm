module Common.Modal exposing (modal)

import Html exposing (a, button, div, hr, Html, i, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


-- example usage
-- modal
--     True
--     OkAction
--     CancelAction
--     [ h4 [] [ text "Heading" ]
--     , h5 [] [ text "Body of modal" ]
--     ]


modal : Bool -> msg -> msg -> List (Html msg) -> Html msg
modal open ok cancel content =
    let
        classList =
            if open then
                "modal modal-open"
            else
                "modal"
    in
        div
            [ class classList ]
            [ div
                [ class "modal-inner container" ]
                [ innerModal ok cancel content ]
            ]


modalHeader : msg -> Html msg
modalHeader cancel =
    div
        [ class "modal-close-icon" ]
        [ a
            [ onClick cancel ]
            [ i [ class "fa fa-times" ] [] ]
        ]


innerModal : msg -> msg -> List (Html msg) -> Html msg
innerModal ok cancel content =
    div
        [ class "modal-content eight columns offset-by-two" ]
        [ modalHeader cancel
        , div [ class "modal-content-inner" ] content
        , hr [ class "modal-buttons-seperator" ] []
        , modalFooter ok cancel
        ]


modalFooter : msg -> msg -> Html msg
modalFooter ok cancel =
    div
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
