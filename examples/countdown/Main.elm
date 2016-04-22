
import Signal exposing (Address, Mailbox)
import Html exposing (..)
import StartApp
import Effects exposing (Effects, Never)
import Timer


app : StartApp.App Model
app =
  StartApp.start
    { init = ( initialModel, Effects.none )
    , update = update
    , view = view
    , inputs = inputs
    }


main : Signal Html
main =
  app.html


-- MODEL

type alias Model =
  { timer : Timer.Model
  }


initialModel : Model
initialModel =
  { timer = Timer.init' 10
  }


-- UPDATE

type Action
  = NoOp
  | TimerAction Timer.Action


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case Debug.log "Main" action of
    NoOp ->
      ( model, Effects.none )

    TimerAction subAction ->
      ( { model | timer = Timer.update subAction model.timer }
      , Effects.none
      )


-- VIEW

view : Address Action -> Model -> Html
view address model =
  div []
    [ text <| Timer.view model.timer
    ]


-- SIGNALS

inputs : List (Signal Action)
inputs =
  [ Signal.map TimerAction Timer.countdown
  ]
