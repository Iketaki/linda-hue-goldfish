io = new RocketIO().connect("http://linda.masuilab.org")
linda = new Linda(io)
ts = new linda.TupleSpace("delta")

io.on "connect", ->
  $("#status").text "Status: #{io.type} connect"

hue_number = Number(location.hash.slice(1))

$ ->
  $("#on").click ->
    ts.write ["hue", hue_number, "on"]

  $("#off").click ->
    ts.write ["hue", hue_number, "off"]

  # From hue document
  # Hue of the light. This is a wrapping value between 0 and 65535. Both 0 and 65535 are red, 25500 is green and 46920 is blue.

  $("#red").click ->
    ts.write ["hue", hue_number, "hsb", 0, 255, 255]

  $("#yellow").click ->
    ts.write ["hue", hue_number, "hsb", 19000, 255, 255]

  $("#green").click ->
    ts.write ["hue", hue_number, "hsb", 25500, 255, 255]

  $("#blue").click ->
    ts.write ["hue", hue_number, "hsb", 46920, 255, 255]

  $("#ok").click ->
    goldfish.exit()

  angle = 0
  cnt = 0
  setInterval =>
    #acc = goldfish.accelerometer()
    gyro = goldfish.gyroscope()
    angle -= (gyro.z * 3)

    range = 75 # 0 < angle < 150
    error_diff = 100

    if angle < -error_diff || angle > range * 2 + error_diff
      goldfish.exit()

    hue = (angle + range) * 65536 / (range*2)
    hue = 65535 if hue > 65535
    hue = 0 if hue < 0

    deg = angle * 90 / range
    deg = 90 if deg > 90
    deg = -90 if deg < -90

    $("#mark").css("-webkit-transform", "rotate(#{deg}deg)")

    cnt += 1
    if cnt == 10
      ts.write ["hue", hue_number, "hsb", hue, 255, 255]
      $("#log").prepend $("<p>").text("hue: #{hue}")
      cnt = 0
  , 50
