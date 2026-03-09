extends Button

@onready var _button1 = $"../HotbarButton1"
@onready var _button2 = $"../HotbarButton2"
@onready var _button3 = $"../HotbarButton3"
@onready var _button4 = $"../HotbarButton4"
@onready var _button5 = $"../HotbarButton5"

func _input(event):
	if event.is_action_pressed("Hotbar1"):
		_button1.set_pressed(true)
		_button2.set_pressed(false)
		_button3.set_pressed(false)
		_button4.set_pressed(false)
		_button5.set_pressed(false)

	if event.is_action_pressed("Hotbar2"):
		_button2.set_pressed(true)
		_button3.set_pressed(false)
		_button1.set_pressed(false)
		_button4.set_pressed(false)
		_button5.set_pressed(false)

	if event.is_action_pressed("Hotbar3"):
		_button3.set_pressed(true)
		_button2.set_pressed(false)
		_button1.set_pressed(false)
		_button4.set_pressed(false)
		_button5.set_pressed(false)

	if event.is_action_pressed("Hotbar4"):
		_button4.set_pressed(true)
		_button5.set_pressed(false)
		_button3.set_pressed(false)
		_button2.set_pressed(false)
		_button1.set_pressed(false)

	if event.is_action_pressed("Hotbar5"):
		_button5.set_pressed(true)
		_button4.set_pressed(false)
		_button3.set_pressed(false)
		_button2.set_pressed(false)
		_button1.set_pressed(false)
