module PasswordGenerator exposing (..)

import Browser
import Html exposing (Html, div, text, button)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)
import CharSet
import Random

type State =
  Ready |
  Generating |
  Generated

type alias Model =
  { availablePools : List (List Char)
  , chosenPools : List (List Char)
  , currentPool : Maybe (List Char)
  , state : State
  , length : Int
  , password : String
  }


type alias Flags =
  {
  }


type Msg =
  Generate |
  NewPoolIndex Int |
  NewCharIndex Int


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


initialModel : Flags -> Model
initialModel flags =
  { availablePools =
      [ CharSet.lowercase
      , CharSet.uppercase
      , CharSet.special
      , CharSet.digits
      ]
  , chosenPools =
      [ CharSet.lowercase
      , CharSet.uppercase
      , CharSet.special
      , CharSet.digits
      ]
  , state = Ready
  , currentPool = Nothing
  , length = 12
  , password = ""
  }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( (initialModel flags), Cmd.none )


randomIndex : List a -> Random.Generator Int
randomIndex list =
  Random.int 0 ((List.length list) - 1)


getElementAtIndex : Int -> List a -> Maybe a
getElementAtIndex idx list =
  List.drop idx list |> List.head


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Generate ->
          ( { model | password = "" }
          , Random.generate NewPoolIndex (randomIndex model.chosenPools)
          )

        NewPoolIndex idx ->
          let
            maybePool = getElementAtIndex idx model.chosenPools
          in
          case maybePool of
            Just pool ->
              ( { model | currentPool = maybePool }
              , Random.generate NewCharIndex (randomIndex pool)
              )

            Nothing ->
              ( model
              , Random.generate NewPoolIndex (randomIndex model.chosenPools)
              )


        NewCharIndex idx ->
          let
            maybePool = getElementAtIndex idx model.chosenPools
          in
          case model.currentPool of
            Nothing ->
              ( model
              , Random.generate NewPoolIndex (randomIndex model.chosenPools)
              )

            Just pool ->
              let
                maybeChar = getElementAtIndex idx pool
              in
              case maybeChar of
                Nothing ->
                  ( model
                  , Random.generate NewCharIndex (randomIndex pool)
                  )

                Just char ->
                  let
                    newPassword = model.password ++ (String.fromChar char)
                    (newCmd, newState) =
                      if (String.length model.password) < model.length then
                        ( Random.generate NewPoolIndex (randomIndex model.chosenPools)
                        , Generating
                        )
                      else
                        ( Cmd.none
                        , Generated
                        )
                  in
                  ( { model | password = newPassword, state = newState }
                  , newCmd
                  )


view : Model -> Html Msg
view model =
  case model.state of
    Ready ->
      div
        []
        [ button [ onClick Generate ] [ text "Generate" ] ]

    Generating ->
      div
        []
        [ button [ disabled True ] [ text "Generating ..." ] ]

    Generated ->
      div
        []
        [ button
            [ onClick Generate ]
            [ text "Generate" ]
        , div [] [ text ("Your password is: " ++ model.password) ]
        ]



main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
