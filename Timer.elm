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
        if secs < 10 then -- add leading zero
          "0" ++ (toString secs)
        else
          toString secs

    minutes =
      let
        mins = (floor ((toFloat model) / 60.0)) % 60
      in
        if mins < 10 then -- add leading zero
          "0" ++ (toString mins)
        else
          toString mins
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
