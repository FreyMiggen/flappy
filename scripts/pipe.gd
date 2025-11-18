extends Node2D
@onready var top_pipe:StaticBody2D = $top
@onready var top_sprite:Sprite2D = $top/sprite
@onready var top_shape:CollisionShape2D=$top/shape

@onready var bottom_pipe:StaticBody2D = $bottom
@onready var bottom_sprite:Sprite2D = $bottom/sprite
@onready var bottom_shape:CollisionShape2D=$bottom/shape

@onready var visibility:VisibleOnScreenNotifier2D=$VisibleOnScreenNotifier2D

@export var offset_max = 50
@export var offset_min = -50

@export var GAP_MAX = 250
@export var GAP_MIN = 70
@export var speed = -15
@export var coin_scene: PackedScene
signal pipe_exit

var original_pipe_height
var bottom_pipe_height
var top_pipe_height


func _ready():
	var right_x = get_viewport_rect().size.x-30
	bottom_pipe.add_to_group(game.GROUP_PIPES)
	top_pipe.add_to_group(game.GROUP_PIPES)
	
	original_pipe_height = top_sprite.get_texture().get_height()
	var gap = generateGap(GAP_MAX,GAP_MIN,25)
	var offset = generateGap(offset_max,offset_min,10)
	set_up_pipe(gap,offset)
	
	visibility.screen_exited.connect(_on_pipe_invisible)
	bottom_pipe.position.x = 0
	top_pipe.position.x = 0
	
	# FOR TESTING
	#position.x = right_x


func init(_spawn_x:float):
	position.x = _spawn_x
	position.y = 0 # Reset Y position to top of screen
	

func set_up_pipe(gap_size,offset):
	# SET THE REAL OFFSET
	var center_y = get_viewport_rect().size.y/2 + offset
	
	# HEIGHT
	top_pipe_height = center_y - gap_size/2
	bottom_pipe_height = get_viewport_rect().size.y - center_y-gap_size/2
	
	#scale sprite
	top_sprite.scale.y = top_pipe_height/original_pipe_height
	bottom_sprite.scale.y = bottom_pipe_height/original_pipe_height
	
	# collision
	var top_collision:RectangleShape2D = top_shape.shape as RectangleShape2D
	top_collision.extents.y = top_pipe_height/2
	var bottom_collision:RectangleShape2D = bottom_shape.shape as RectangleShape2D
	bottom_collision.extents.y = bottom_pipe_height/2
	
	# POSITION
	top_pipe.position.y = top_pipe_height/2
	bottom_pipe.position.y = center_y+gap_size/2 + bottom_pipe_height/2
	
	# COINS
	set_up_coins(gap_size,offset)
	
	
#func set_up_pipe(gap_size,offset):
#
	#var center_y = get_viewport_rect().size.y/2
	#var right_x = get_viewport_rect().size.x-30
	#
	#
	#var top_gap = gap_size/2 + offset
	#var bottom_gap = gap_size - top_gap
	#
	## height
	#top_pipe_height = center_y-top_gap
	#bottom_pipe_height = center_y-bottom_gap
	#
	##scale sprite
	#top_sprite.scale.y = top_pipe_height/original_pipe_height
	#bottom_sprite.scale.y = bottom_pipe_height/original_pipe_height
	#
	## collision
	#var top_collision:RectangleShape2D = top_shape.shape as RectangleShape2D
	#top_collision.extents.y = top_pipe_height/2
	#var bottom_collision:RectangleShape2D = bottom_shape.shape as RectangleShape2D
	#bottom_collision.extents.y = bottom_pipe_height/2
	#
	## postion y
	#top_pipe.position.y = top_pipe_height/2
	#bottom_pipe.position.y = center_y+bottom_gap+bottom_pipe_height/2
	##print("TOP PIPE: ",top_pipe.position.y," BOTTOM PIPE: ",bottom_pipe.position.y)
	##print("GAP: ",gap_size)
	#print("HEIGHTS: ",top_pipe_height," ",bottom_pipe_height)
	#print("OFFSET: ",offset)
	##print("COLLISION: ",top_collision.extents.y*2, " ",bottom_collision.extents.y*2)
	#
	## SETUP COIN
	##var coin = coin_scene.instantiate()
	##await coin.ready # wait for _ready to complete
	##var coin_size = coin.get_size()
	#
	#set_up_coins(gap_size,offset)


func set_up_coins(gap_size,offset):
	var coin = coin_scene.instantiate()
	var coin_size = coin.coin_size
	var hasCoin = randf()
	if hasCoin >= 0:
		var coinNumber = int(gap_size/coin_size)
		var real_center_y = get_viewport_rect().size.y/2 + offset
		print("REAL CENTER: ",real_center_y)
		if coinNumber >= 2:
			# set coin
			coin.position.y = real_center_y
			coin.position.x = 0
			#CONNECT WITH PARAMETER HANDLING
			coin.collected.connect(_on_coin_collected)
			add_child(coin)
		
		if coinNumber >=4:
			# set 3 coins
			var shift = 10
			var upper_coin = coin_scene.instantiate()
			upper_coin.collected.connect(_on_coin_collected)
			upper_coin.position.y = real_center_y - coin_size- shift
			upper_coin.position.x = 0
			add_child(upper_coin)
			
			var lower_coin = coin_scene.instantiate()
			lower_coin.collected.connect(_on_coin_collected)
			lower_coin.position.y = real_center_y + coin_size + shift
			lower_coin.position.x = 0
			add_child(lower_coin)

func _on_coin_collected(score_value:int):
	print("SCORE GAINED: ",score_value)
	pass
				
func generateGap(max_gap,min_gap,gap):
	var steps = int((max_gap-min_gap)/gap)
	var rand_int = randi_range(0,steps)
	var gap_size = min_gap + gap*rand_int
	return gap_size

		
func _process(delta):
	position.x += speed*delta



func _on_pipe_invisible():
	print("PIPE EXITED!")
	queue_free()
	
	pipe_exit.emit()
	pass # Replace with function body.
