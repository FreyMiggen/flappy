extends Node

class_name GameManager

signal score_changed(new_score:int)
signal high_score_changed(new_high_score)

const GROUP_PIPES 	= "pipes"
const GROUP_GROUNDS 	= "grounds"
const GROUP_BIRDS 	= "birds"

const MEDAL_BRONZ	= 10
const MEDAL_SILVER	= 20
const MEDAL_GOLD		= 30
const MEDAL_PLATINUM	= 50

static var score: int =0
static var high_score:int = 0

# Reference to the singleton instance
static var instance:GameManager

func _ready():
	instance = self # Set static reference
	
# Instance method that can emit signals
func _add_score_instance(points: int):
	score += points
	score_changed.emit(score)
	
	if score > high_score:
		high_score = score
		high_score_changed.emit(high_score)

# Static method that delegates to instance
static func add_score(points: int):
	if instance:
		instance._add_score_instance(points)
	else:
		push_error("GameManager instance not found!")

static func reset():
	score = 0
	if instance:
		instance.score_changed.emit(score)
