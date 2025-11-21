extends CanvasLayer

@onready var start_button = $StartButton
@onready var message = $MessageLabel
@onready var score = $ScoreLabel

# Called when the node enters the scene tree for the first time.

@export var normal_icon: Texture2D
@export var pressed_icon: Texture2D
signal start_game


func _ready():
	# Connect the pressed signals using Godot 4.x syntax
	GameManager.instance.score_changed.connect(update_score)
	start_button.pressed.connect(_on_start_button_pressed)
	#start_button.button_up.connect(_on_start_button_released)
	message.hide()
	
func update_score(new_score:int):
	score.text = str(new_score)

func show_message(text):
	message.text = text
	message.show()
	$MessageTimer.start()
	await $MessageTimer.timeout
	
	
	
func _on_start_button_pressed():
	start_button.icon = pressed_icon
	start_button.set_deferred("icon",pressed_icon)
	# Make a one-shot timer and wait for it to finish
	await get_tree().create_timer(0.5).timeout
	# make it invisible and non-interactable
	#start_button.visible = false
	
	start_button.hide()
	
	await show_message("START FLAPPING!")
	start_game.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_message_timer_timeout() -> void:
	print("HIDE GAME MESSAGE")
	message.hide()
	pass # Replace with function body.
