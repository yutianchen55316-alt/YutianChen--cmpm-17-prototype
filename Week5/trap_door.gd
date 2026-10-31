
extends Area2D

@onready var door_sprite: Sprite2D = $Sprite2D
@onready var bomb_sprite: Sprite2D = $BombSprite

@onready var message_panel: PanelContainer = get_node(
    "../CanvasLayer/CenterContainer/PanelContainer"
)

@onready var message_label: Label = get_node(
    "../CanvasLayer/CenterContainer/PanelContainer/VBoxContainer/MessageLabel"
)

@onready var close_button: Button = get_node(
    "../CanvasLayer/CenterContainer/PanelContainer/VBoxContainer/CloseButton"
)

var player_near: bool = false
var opened: bool = false

func _ready():
	monitoring = true
	bomb_sprite.hide()
	message_panel.hide()

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	close_button.pressed.connect(_on_close_pressed)

func _process(_delta):
	if player_near and not opened:
		if Input.is_action_just_pressed("interact"):
			if GameManager.has_key:
				open_door()
			else:
				print("You need the key!")

func _on_body_entered(body):
	if body.name == "player":
		player_near = true

func _on_body_exited(body):
	if body.name == "player":
		player_near = false

func open_door():
	opened = true
	GameManager.has_key = false

	# Door disappears
	door_sprite.hide()

	# Bomb appears
	bomb_sprite.show()
	print("Bomb appeared!")

	# Wait 1.5 seconds
	await get_tree().create_timer(1.5).timeout

	if not is_inside_tree():
		return

	# Bomb disappears
	bomb_sprite.hide()

	# Show trap message
	message_label.text = "WOW! It was just a trap!"
	message_panel.show()

func _on_close_pressed():
	message_panel.hide()
