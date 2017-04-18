module Main exposing (main)

import Html exposing (program)
import Time exposing (every, second)
import Models exposing (initialModel, Model)
import Msgs exposing (Msg)
import Update exposing (update)
import View exposing (view)
import Timer.Msgs


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map Msgs.Timer (every second Timer.Msgs.Tick)


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
