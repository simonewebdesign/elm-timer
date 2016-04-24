module Timer
  ( Model
  , init, init'
  , view
  , Action, update
  , addLeadingZero
  , clock
  , tick, countdown
  ) where

{-| This module provides a simple timer that you can easily integrate in your Elm app.
It's even easier if you are following the [the Elm Architecture][arch] and using
[start-app][].

[arch]: https://github.com/evancz/elm-architecture-tutorial
[start-app]: http://package.elm-lang.org/packages/evancz/start-app/latest/

# Types
@docs Model, Action

# Functions
@docs init, init', view, update

# Signals
@docs tick, countdown

# Extras
@docs addLeadingZero, clock
-}

import Signal exposing (map, foldp)
import Time exposing (every, second)


{-| Type alias that represents the internal value of a timer.
It's basically just a simple counter.
-}
type alias Model = Int


{-| Initialize a timer.
-}
init : Model
init =
  0


{-| Initialize a timer with a starting value, in seconds.

    Timer.init' (round Time.hour)

    -- or, if you like magic numbers
    Timer.init' 3600
-}
init' : Model -> Model
init' model =
  model


{-| Provides a way to display the timer, in a format that
looks like 01:30 (always with leading zeros).

    Timer.view (Timer.init 30) -- will return "00:30"
-}
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


{-| A type that you can use to update the timer.
A `Tick` moves forward, a `Tock` goes backwards.
-}
type Action
  = Tick
  | Tock


{-| Updates the model.
This is how you can forward actions to a timer using the Elm Architecture:

    TimerAction subAction ->
      ( { model | timer = Timer.update subAction model.timer }
      , Effects.none
      )
-}
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


{-| Adds a leading zero to a number *only if* it's a single digit.

    addLeadingZero 0 == "00"
    addLeadingZero 1 == "01"
    addLeadingZero 12 == "12"
-}
addLeadingZero : number -> String
addLeadingZero num =
  if num < 10 then
    "0" ++ (toString num)
  else
    toString num


{-| A counter that increments every second.
-}
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


{-| A `Signal` that tells a `Timer` to step forward.
Use this if you want a timer that goes to the future.
-}
tick : Signal Action
tick =
  map (always Tick) clock


{-| A `Signal` that tells a `Timer` to step backwards.
Use this if you want a timer that goes to the past.
This will have no effect if the time is already expired (00:00).
-}
countdown : Signal Action
countdown =
  map (always Tock) clock
