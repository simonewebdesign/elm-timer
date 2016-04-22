module Timer where


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
