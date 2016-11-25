# Elm Timer

A simple **digital clock** that can either count to a future date or go backwards (countdown).

## This project is no longer maintained

You can use it if you're still on Elm 0.16, however if you're using a more recent version of Elm there is an easier way of doing the same thing this library does. For example, for Elm 0.18 ([code taken from the guide](https://guide.elm-lang.org/architecture/effects/time.html)):

``` elm
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model = Time


init : (Model, Cmd Msg)
init =
  (0, Cmd.none)


-- UPDATE

type Msg
  = Tick Time


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (newTime, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick


-- VIEW

view : Model -> Html Msg
view model =
  let
    angle =
      turns (Time.inMinutes model)

    handX =
      toString (50 + 40 * cos angle)

    handY =
      toString (50 + 40 * sin angle)
  in
    svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#023963" ] []
      ]
```

Below you'll find instructions to set up this library, in case you're still interested.

---


## Getting started

**No dependencies** are required. Just grab the package and you're good to go.

    elm package install simonewebdesign/elm-timer

A couple [examples](https://github.com/simonewebdesign/elm-timer/tree/master/examples) are provided: [simple](https://github.com/simonewebdesign/elm-timer/tree/master/examples/simple) and [countdown](https://github.com/simonewebdesign/elm-timer/tree/master/examples/countdown). The former doesn't use [StartApp](https://github.com/evancz/start-app); the latter does.

You can either have a look at the examples or read below to get started.

---

### Wire it up with `StartApp`

First of all, import the module:

``` elm
import Timer
```

Then add it to your model:

``` elm
type alias Model =
  { timer : Timer.Model }
```

Provide an initial value for it:

``` elm
initialModel =
  { timer = Timer.init }
```

Define an action:

``` elm
type Action
  = NoOp
  | TimerAction Timer.Action
```

Update your `update`:

``` elm
update action model =
  case action of
    NoOp ->
      ( model, Effects.none )

    TimerAction subAction ->
      ( { model | timer = Timer.update subAction model.timer }
      , Effects.none
      )

    ...
```

Add it to your `view`:

``` elm
view address model =
  text (Timer.view model.timer)
```

And feed it to `StartApp`:

``` elm
app =
  StartApp.start
    { init = ( initialModel, Effects.none )
    , update = update
    , view = view
    , inputs = [ Signal.map TimerAction Timer.tick ]
    }
```

If everything's wired up correctly, you should be able to see a timer in your app.


### A backwards clock (aka countdown)

If you want to reverse the clock, just use `Timer.countdown` instead of `Timer.tick`.
For example if you're using `StartApp` your configuration will look like:

``` elm
app =
  StartApp.start
    { inputs = [ Signal.map TimerAction Timer.countdown ]
    , ...
    }
```


### Extras

There are a couple of things that are being used internally, but I figured they might be useful.

#### `clock`

The `clock` function is a `Signal Int` that receives a new value every second.

#### `addLeadingZero`

Another function that just adds a leading zero to a number *only if* it's just a single digit.
The signature is `addLeadingZero : number -> String`.
