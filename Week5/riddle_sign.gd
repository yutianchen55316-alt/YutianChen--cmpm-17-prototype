
extends Node2D

# ==================================
# Node references
# ==================================

@onready var area = $Area2D

@onready var center_container = $CanvasLayer/CenterContainer

@onready var panel = $CanvasLayer/CenterContainer/PanelContainer

@onready var question = $CanvasLayer/CenterContainer/PanelContainer/VBoxContainer/QuestionLabel

@onready var result = $CanvasLayer/CenterContainer/PanelContainer/VBoxContainer/ResultLabel

@onready var answer_a = $CanvasLayer/CenterContainer/PanelContainer/VBoxContainer/AnswerA

@onready var answer_b = $CanvasLayer/CenterContainer/PanelContainer/VBoxContainer/AnswerB

@onready var answer_c = $CanvasLayer/CenterContainer/PanelContainer/VBoxContainer/AnswerC

@onready var close_button = $CanvasLayer/CenterContainer/PanelContainer/VBoxContainer/CloseButton


# ==================================
# Player detection
# ==================================

var player_near = false
var player_body: CharacterBody2D = null


# ==================================
# Initialize
# ==================================

func _ready():

	# Make UI cover the game viewport
	center_container.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	center_container.position = Vector2.ZERO
	center_container.size = get_viewport_rect().size

	# Set puzzle window size
	panel.custom_minimum_size = Vector2(420, 260)

	# Center the puzzle window
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	# Set question text
	question.text = "I follow you in daylight, but disappear in darkness. What am I?"

	question.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	question.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	# Set answer text
	answer_a.text = "A. The Moon"
	answer_b.text = "B. A Shadow"
	answer_c.text = "C. The Wind"

	close_button.text = "Close"

	# Hide puzzle initially
	panel.hide()

	result.text = ""

	# Connect player detection
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

	# Connect answer buttons
	answer_a.pressed.connect(_wrong_answer)
	answer_b.pressed.connect(_correct_answer)
	answer_c.pressed.connect(_wrong_answer)

	# Connect close button
	close_button.pressed.connect(_close_riddle)

	print("Riddle sign ready!")


# ==================================
# Detect E key
# ==================================

func _input(event):

	if event.is_action_pressed("interact") and not event.is_echo():

		print("E key detected!")
		print("Player near: ", player_near)

		if player_near:

			if not panel.visible:
				_open_riddle()
			else:
				_close_riddle()

			get_viewport().set_input_as_handled()


# ==================================
# Open puzzle
# ==================================

func _open_riddle():

	result.text = ""

	center_container.show()
	panel.show()

	print("Riddle opened!")


# ==================================
# Detect player entering
# ==================================

func _on_body_entered(body):

	print("Something entered: ", body.name)

	if body is CharacterBody2D and body.name == "player":

		player_body = body
		player_near = true

		print("Player detected!")


# ==================================
# Detect player leaving
# ==================================

func _on_body_exited(body):

	print("Something exited: ", body.name)

	if body == player_body:

		player_near = false
		player_body = null

		print("Player left!")


# ==================================
# Correct answer
# ==================================

func _correct_answer():

	result.text = "Correct! The answer is a shadow."

	print("Correct answer!")


# ==================================
# Wrong answer
# ==================================

func _wrong_answer():

	result.text = "Wrong answer! Try again."

	print("Wrong answer!")


# ==================================
# Close puzzle
# ==================================

func _close_riddle():

	panel.hide()

	print("Riddle closed!")
