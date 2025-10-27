extends Node2D

@onready var bird:RigidBody2D = $bird
@onready var pipes:Node2D = $pipe_spawner

func _ready():
	var center_x = get_viewport_rect().size.x/2
	var center_y = get_viewport_rect().size.y/2
	bird.init(center_x,center_y)
	bird.get_hit.connect(_on_game_over)

func _on_game_over():
	print("GET HIT!")
	get_node("sfx_die").play()
	
