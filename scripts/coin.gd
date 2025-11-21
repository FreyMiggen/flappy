extends Area2D

enum CoinType {BRONZE, SILVER, GOLD}

#@export var bronze_texture:Texture2D
#@export var silver_texture:Texture2D
#@export var gold_texture:Texture2D

@export var coin_size:float= 22.0

@onready var bronze_texture: Texture2D = preload("res://sprites/medal_bronze.png")
@onready var silver_texture: Texture2D = preload("res://sprites/medal_silver.png")
@onready var gold_texture: Texture2D = preload("res://sprites/medal_gold.png")

@onready var sprite = $sprite
@onready var shape:CollisionShape2D = $shape
# Called when the node enters the scene tree for the first time.
signal collected(score_value:int)

var coin_type: CoinType

var score_values ={
	CoinType.BRONZE:3,
	CoinType.SILVER:5,
	CoinType.GOLD: 10
}

func _ready() -> void:
	print(get_size())
	setup_random_type()
	# SETUP POSITION FOR TESTING
	#position.x = 100
	#position.y = 100
	#print(coin_type)
	print(get_score())
	
	
	body_entered.connect(_on_body_entered)
	pass # Replace with function body.

func setup_random_type():
	var random_value = randf()
	
	if random_value < 0.6:
		coin_type = CoinType.BRONZE
	elif random_value < 0.9:
		coin_type = CoinType.SILVER
	else:
		coin_type = CoinType.GOLD
	
	# setup the correct texture
	match coin_type:
		CoinType.BRONZE:
			sprite.texture = bronze_texture
		CoinType.SILVER:
			sprite.texture = silver_texture
		CoinType.GOLD:
			sprite.texture = gold_texture
	
	sprite.set_deferred("texture",sprite.texture)
	print(sprite.texture)

func set_collision_shape():
	var texture_size = Vector2(16,16)
	var rect_shape = shape.shape as RectangleShape2D
	rect_shape.extents = texture_size/2

func get_score()->int:
	return score_values[coin_type]

func get_size():
	return sprite.get_texture().get_height()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(game.GROUP_BIRDS):
		collected.emit(get_score())
		collect_coin()

func collect_coin():
	shape.set_deferred("disabled",true)
	
	# Use staitc wrapper
	GameManager.add_score(get_score())
	queue_free()
	
