
extends Area2D

var player_near: bool = false

func _ready():
	monitoring = true
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	print("Moonlight Key is ready!")

func _process(_delta):
	if player_near and Input.is_action_just_pressed("interact"):
		GameManager.has_key = true
		print("Key collected!")
		queue_free()

func _on_body_entered(body):
	print("Body entered: ", body.name)
	if body.name == "player":
		player_near = true
		print("Player can pick up the key!")

func _on_body_exited(body):
	if body.name == "player":
		player_near = false
