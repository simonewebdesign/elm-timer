module Timer
  ( Model
  , init, init'
  , view
  , Action, update
  , addLeadingZero
  , clock
  , tick, countdown
  ) where

import Signal exposing (map, foldp)
import Time exposing (every, second)


type alias Model = Int


init : Model
init =
  0


init' : Model -> Model
init' model =
  model


view : Model -> String
view model =
  let
    seconds =
      let
        secs = model % 60
      in
        addLeadingZero secs

    minutes =
      let
        mins = model // 60 % 60
      in
        addLeadingZero mins
  in
    minutes ++ ":" ++ seconds


type Action
  = Tick
  | Tock


update : Action -> Model -> Model
update action model =
  case action of
    Tick ->
      model + 1

    Tock ->
      if model > 0 then
        model - 1
      else
        model


addLeadingZero : number -> String
addLeadingZero num =
  if num < 10 then
    "0" ++ (toString num)
  else
    toString num


clock : Signal Model
clock =
  foldp (+) 0 (every second)
    |> map round
  -- or:
  --     relativeTime tick ~> Time.inSeconds >> round
  --
  -- or:
  --     every second
  --       |> relativeTime
  --       |> map round


tick : Signal Action
tick =
  map (always Tick) clock


countdown : Signal Action
countdown =
  map (always Tock) clock
