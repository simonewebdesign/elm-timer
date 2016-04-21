
import Signal exposing (Address, Mailbox)
import Task exposing (Task)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Time exposing (Time, timestamp, inSeconds)
import Timer

main : Signal Html
main =
  Signal.map2 (view actions.address) model seconds


-- MODEL

type alias Model =
  { secondsElapsed : Seconds
  }

type alias Seconds = Int


initialModel : Model
initialModel =
  { secondsElapsed = 0
  }


-- UPDATE

type Action
  = NoOp


update : Action -> Model -> Model
update action model =
  case Debug.log "Main" action of
    NoOp ->
      model


-- VIEW

view : Address Action -> Model -> Seconds -> Html
view address model seconds =
  div []
    [
      text <| Timer.view seconds
    ]


-- SIGNALS

initialTimestamp : Signal Time
initialTimestamp =
  Signal.constant ()
    |> timestamp
    |> Signal.map fst


currentTime : Signal Time
currentTime =
  Time.every Time.second


seconds : Signal Seconds
seconds =
  Signal.map2 (-) currentTime initialTimestamp
    |> Signal.map inSeconds
    |> Signal.map round


actions : Mailbox Action
actions =
  Signal.mailbox NoOp


model : Signal Model
model =
  Signal.foldp update initialModel actions.signal


tasksMailbox : Mailbox (Task x ())
tasksMailbox =
  Signal.mailbox (Task.succeed ())


port tasks : Signal (Task x ())
port tasks =
  tasksMailbox.signal
