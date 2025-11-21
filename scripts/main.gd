extends Node2D
class_name Main

@onready var bird:RigidBody2D = $bird
@onready var pipes:Node2D = $pipe_spawner

@onready var hud = $HUD

var game_started:bool = false

func _ready():
	
	var center_x = get_viewport_rect().size.x/2
	var center_y = get_viewport_rect().size.y/2
	bird.init(center_x,center_y)
	bird.get_hit.connect(_on_game_over)
	
	hud.start_game.connect(_on_start_game)

func _on_start_game():
	game_started = true
	

func _on_game_over():
	print("GET HIT!")
	get_node("sfx_die").play()
	# clear all pipes
	get_tree().call_group(game.GROUP_PIPES,"queue_free")
	
	
