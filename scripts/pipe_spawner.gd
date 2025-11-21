extends Node2D

@export var pipe_scene:PackedScene

# BLOCK UPDATES UNTIL GAME STARTS

func _ready() -> void:
	# we do not spawn pipes here -> wait for game start
	pass

func spawn_initial_pipes():
	var x_size = get_viewport_rect().size.x
	for x_cor in [x_size/4, x_size*3/4]:
		var pipe = pipe_scene.instantiate()
		pipe.init(x_cor)
		pipe.pipe_exit.connect(_on_pipe_exited)
		add_child(pipe)
	

func _process(delta):
	var main = get_tree().current_scene
	if main is Main and not main.game_started:
		print("GAME NOT STARTED YET!")
		return
	# GAME STARTED -> SPAWN PIPES
	if get_child_count() == 0: # no current child -> no pipe added
		spawn_initial_pipes()
	

func _on_pipe_exited():
	var x_right = get_viewport_rect().size.x
	# when there is pipe exit, add a new one
	var pipe=pipe_scene.instantiate()
	pipe.init(x_right)
	pipe.pipe_exit.connect(_on_pipe_exited)
	add_child(pipe)
