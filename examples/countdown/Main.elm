
import Signal exposing (Address, Mailbox)
--import Task exposing (Task)
import Html exposing (..)
--import Html.Attributes exposing (..)
--import Html.Events exposing (onClick)
import StartApp
import Effects exposing (Effects, Never)
import Time exposing (Time)
import Timer
--import Signal.Extra exposing ((~>))
--import Signal.Time exposing (relativeTime)


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
  { counter : Seconds
  }


initialModel : Model
initialModel =
  { counter = round secondsToEnd
  }


-- UPDATE

type Action
  = NoOp
  | UpdateCounter

update : Action -> Model -> ( Model, Effects Action )
update action model =
  case Debug.log "Main" action of
    NoOp ->
      ( model, Effects.none )

    UpdateCounter ->
      ( { model | counter = if model.counter > 0 then model.counter - 1 else 0 }
      , Effects.none
      )


-- VIEW

view : Address Action -> Model -> Html
view address model =
  div []
    [ text <| Timer.view model.counter
    ]


-- SIGNALS

type alias Seconds = Int

secondsToEnd : Time
secondsToEnd = 5


seconds : Signal Seconds
seconds =
  Signal.foldp (+) 0 (Time.every Time.second)
    |> Signal.map round
  -- or:
  --     relativeTime tick ~> Time.inSeconds >> round
  --
  -- or:
  --     Time.every Time.second
  --       |> relativeTime
  --       |> Signal.map round


inputs : List (Signal Action)
inputs =
  [ Signal.map (always UpdateCounter) seconds
  ]


-- This demo app is not using tasks
--port tasks : Signal (Task Never ())
--port tasks =
--  app.tasks
