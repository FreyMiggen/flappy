extends CanvasLayer

@onready var start_button = $StartButton
# Called when the node enters the scene tree for the first time.

@export var normal_icon: Texture2D
@export var pressed_icon: Texture2D


func _ready():
	# Connect the pressed signals using Godot 4.x syntax
	start_button.pressed.connect(_on_start_button_pressed)
	#start_button.button_up.connect(_on_start_button_released)

func _on_start_button_pressed():
	start_button.icon = pressed_icon
	start_button.set_deferred("icon",pressed_icon)
	# Make a one-shot timer and wait for it to finish
	await get_tree().create_timer(1.0).timeout
	# make it invisible and non-interactable
	start_button.visible = false
	

#func _on_start_button_released():
	#start_button.icon = normal_icon
		

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
