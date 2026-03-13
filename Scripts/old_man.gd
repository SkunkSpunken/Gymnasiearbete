extends CharacterBody2D

@onready var _anim_sprite = $AnimatedSprite2D
@onready var _talk = $Talk
@onready var _sell = $Sell
@onready var _area = $Area2D/CollisionShape2D
@onready var _body = $"."

var player_inside = false

func _ready() -> void:
	_anim_sprite.play("Idle")
	_talk.visible = false
	_sell.visible = false


func _process(delta: float) -> void:
	_agree_talk_npc()

func _talk_npc(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = true
		_talk.visible = true


func _no_talk_anymore(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = false
		_talk.visible = false
		_sell.visible = false

func _agree_talk_npc():
	if player_inside:
		if Input.is_action_just_pressed("UseItem"):
			_sell.visible = true
			_talk.visible = false
		if _sell.visible and Input.is_action_just_pressed("Hotbar1"):
			var amount = Global.wood
			Global.wood = 0
			Global.diamond += 3 * amount
			
		elif _sell.visible and Input.is_action_just_pressed("Hotbar2"):
			var amount = Global.wheat
			Global.wheat = 0
			Global.diamond += amount
			
		elif _sell.visible and Input.is_action_just_pressed("Hotbar3"):
			var amount = Global.tomato
			Global.tomato = 0
			Global.diamond += 2 * amount
