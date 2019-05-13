module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, button, div, form, h1, img, input, label, option, select, text)
import Html.Attributes exposing (src, type_)
import Html.Events exposing (on, onClick, onInput, onSubmit)
import Http
import Json.Decode as Json
import Json.Encode as Encode



---- MODEL ----
-- We define out model which is just based on the inputs we expect in the form.


type alias Model =
    { name : String
    , email : String
    , community : String
    , tosAgreement : String
    }



-- We need to define our initial model which contains empty strings


init : ( Model, Cmd Msg )
init =
    ( { name = ""
      , email = ""
      , community = ""
      , tosAgreement = ""
      }
    , Cmd.none
    )



---- UPDATE ----
-- The Msg is the message that we need to act on in our update application. Each of the
-- inputs will receive one of these messages.


type Msg
    = ChangeName String
    | ChangeEmail String
    | ChangeCommunity String
    | ChangeTOSAgreement String
    | SubmitData
    | GotUser (Result Http.Error String)



-- For each message we accordingly update the model attribute.


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg " msg of
        ChangeName name ->
            ( { model | name = name }, Cmd.none )

        ChangeEmail email ->
            ( { model | email = email }, Cmd.none )

        ChangeCommunity community ->
            ( { model | community = community }, Cmd.none )

        ChangeTOSAgreement tosAgreement ->
            ( { model | tosAgreement = tosAgreement }, Cmd.none )

        SubmitData ->
            ( model, submitData model )

        GotUser (Ok result) ->
            ( model, Cmd.none )

        GotUser (Err _) ->
            ( model, Cmd.none )


baseUrl =
    "http://localhost:5000/example/api/users"


submitData : Model -> Cmd Msg
submitData model =
    let
        url =
            baseUrl

        body =
            encodeModel model

        header =
            Http.header "Content-Type" "application/json"
    in
    Http.request
        { body = body
        , method = "POST"
        , headers = [ header ]
        , url = url
        , expect = Http.expectJson GotUser (Json.field "result" Json.string)
        , timeout = Nothing
        , tracker = Nothing
        }



-- Encode the JSON object so it can be sent across the wire to the script


encodeModel model =
    Http.jsonBody <|
        Encode.object
            [ ( "name", Encode.string model.name )
            , ( "email", Encode.string model.email )
            , ( "community", Encode.string model.community )
            , ( "tosAgreement", Encode.string model.tosAgreement )
            ]



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Simple Elm Form" ]
        , form [ onSubmit SubmitData ]
            [ div []
                [ label [] [ text "Name:" ]
                , input [ type_ "text", onInput ChangeName ] []
                , label [] [ text "Email:" ]
                , input [ type_ "text", onInput ChangeEmail ] []
                , label [] [ text "Community:" ]
                , select [ onInput ChangeCommunity ]
                    [ option [] [ text "UiT" ]
                    , option [] [ text "UiO" ]
                    , option [] [ text "UiB" ]
                    , option [] [ text "NTNU" ]
                    ]
                , label [] [ text "Terms of Service" ]
                , input [ type_ "checkbox", onInput ChangeTOSAgreement ] [ text "I agree" ]
                , button [ onClick SubmitData ] [ text "Submit Data" ]
                ]
            ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
