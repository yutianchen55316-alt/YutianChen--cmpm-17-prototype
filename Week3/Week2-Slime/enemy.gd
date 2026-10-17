
extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

func _physics_process(delta):
	if player_chase and is_instance_valid(player):		position += (player.global_position - global_position).normalized() * speed * delta

func _on_detection_area_body_entered(body):
	if body.name == "player":
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		player_chase = false
