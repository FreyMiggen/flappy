extends Node2D

@export var pipe_scene:PackedScene

func _ready() -> void:
	# initiate 2 pipes
	var x_size = get_viewport_rect().size.x
	for x_cor in [x_size/4,x_size*3/4]:
		print("PIPE ADDED!")
		var pipe = pipe_scene.instantiate()
		pipe.init(x_cor)
		pipe.pipe_exit.connect(_on_pipe_exited)
		add_child(pipe)
	

func _process(delta):
	pass

func _on_pipe_exited():
	var x_right = get_viewport_rect().size.x
	# when there is pipe exit, add a new one
	var pipe=pipe_scene.instantiate()
	pipe.init(x_right)
	pipe.pipe_exit.connect(_on_pipe_exited)
	add_child(pipe)
