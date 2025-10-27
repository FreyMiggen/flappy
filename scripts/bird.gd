extends RigidBody2D

@onready var state = FlyingState.new(self)
signal state_changed
signal get_hit

const STATE_FLYING		= 0
const STATE_FLAPPING		= 1
const STATE_HIT		= 2
const STATE_GROUNDED		=3
var prev_state = STATE_FLAPPING

var speed = 0

func _ready():
	contact_monitor = true
	max_contacts_reported = 8  # any number ≥1
	add_to_group(game.GROUP_BIRDS)
	#body_entered.connect(_on_body_entered)
	
	init(130,250)
	

func _on_body_entered(body: Node) -> void:
	print("BODY ENTERED!")
	if state.has_method("on_body_entered"):
		state.on_body_entered(body)
		
func _physics_process(delta: float) -> void:
	state.update(delta)

func init(position_x:float,position_y:float):
	position.x = position_x
	position.y = position_y
	
func _input(event):
	#only get called when there is input from the user
	if get_colliding_bodies().size() > 0:
		print("Currently colliding with: ", get_colliding_bodies())
	state.input(event)
	
func set_state(new_state):
	prev_state = get_state()
	state.exit()
	if new_state == STATE_FLYING:
		state = FlyingState.new(self)
	elif new_state == STATE_FLAPPING:
		state = FlappingState.new(self)
	
	state_changed.emit()
	pass

func get_state():
	if state is FlyingState:
		return STATE_FLYING
	elif state is FlappingState:
		return STATE_FLAPPING


	
	pass # Replace with function body.

class FlyingState:
	var bird
	var prev_gravity_scale
	func _init(bird):
		self.bird = bird
		#bird.get_node("anim").play("fly")
		bird.get_node("anim_sprite").play("fly")
		prev_gravity_scale = bird.get_gravity_scale()
		bird.set_linear_velocity(Vector2(bird.speed,0))
		bird.rotation = 0
		#print("ROTATION: ",bird.rotation)
		bird.set_angular_velocity(0)
		bird.set_gravity_scale(0)
		pass
	func update(delta):
		pass
	
	func input(event):
		if event.is_action_pressed("switch"):
			bird.set_state(STATE_FLAPPING)
		#if event is InputEventKey and event.pressed:
			#if event.keycode == KEY_ENTER:
				#bird.set_state(STATE_FLAPPING)
				
	func on_body_entered(other_body):
		if other_body.is_in_group(game.GROUP_PIPES):
			bird.set_state(bird.STATE_HIT)
		elif other_body.is_in_group(game.GROUP_GROUNDS):
			bird.set_state(bird.STATE_GROUNDED)
		
	func exit():
		bird.set_gravity_scale(prev_gravity_scale)
		#bird.get_node("anim").stop()
		#bird.get_node("anim_sprite").position = Vector2(0,0)
		pass

class FlappingState:
	var bird
	func _init(bird):
		self.bird = bird
		bird.get_node("anim_sprite").play("fly")
		#bird.set_gravity_scale(1.0)
		bird.set_linear_velocity(Vector2(0,bird.get_linear_velocity().y))
		flap()

	func update(delta):
		# adjust rotation and velocity during hiking and flopping
		if bird.rotation < deg_to_rad(-30):
			bird.rotation = deg_to_rad(-30)
			bird.set_angular_velocity(0)
		# bird is flopping downward
		if bird.get_linear_velocity().y >0:
			bird.set_angular_velocity(1.5)
			
	func on_body_entered(other_body):
		print("HITTTTTTT")
		if other_body.is_in_group(game.GROUP_PIPES):
			bird.set_state(bird.STATE_HIT)
		elif other_body.is_in_group(game.GROUP_GROUNDS):
			bird.set_state(bird.STATE_GROUNDED)
		
		# EMIT GET_HIT SIGNAL
		
		bird.get_hit.emit()
		
			
	func input(event):
		if event.is_action_pressed("switch"):
			bird.set_state(STATE_FLYING)
		elif event.is_action_pressed("flap"):
			flap()
			
	func flap():
		# flying upward
		bird.set_linear_velocity(Vector2(0, -175))
		bird.set_angular_velocity(-3)
		#print("flap")
		#print(bird.position)
		#bird.get_node("anim").play("flap")
		pass
	
	func exit():
		pass

class HitState:
	var bird
	func _init(bird):
		self.bird = bird
		bird.set_linear_velocity(Vector2(0,0))
		bird.set_angular_speed(2)
		# keep the same gravity scale as in flapping state
		var other_body = bird.get_colliding_bodies()[0]
		bird.add_collision_exception_with(other_body)
		
		pass
	func update(delta):
		pass
	func input(event):
		pass
	func on_body_entered(other_body):
		if other_body.is_in_group(game.GROUP_GROUNDS):
			bird.set_state(bird.STATE_GROUNDED)
		pass
	
	func exit():
		pass

class GroundedState:
	var bird
	func _init(bird):
		self.bird = bird
		bird.set_linear_velocity(Vector2(0,0))
		bird.set_angular_velocity(0)
		if bird.prev_state != bird.STATE_HIT:
			bird.get_node("sfx_hit").play()
		pass
	func update(delta):
		pass	
	func input(event):
		pass
	func exit():
		pass
	
	
	
