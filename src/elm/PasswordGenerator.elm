module PasswordGenerator exposing (..)

import Browser
import Html exposing (Html, div, text)

type alias Model =
  {
    password : String
  }


type alias Flags =
  {
  }


type Msg =
  Noop


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { password = "" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
          ( model, Cmd.none )


view : Model -> Html Msg
view model =
  div
    []
    [ text "Password generator" ]


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
