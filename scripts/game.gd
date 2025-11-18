extends Node

const GROUP_PIPES 	= "pipes"
const GROUP_GROUNDS 	= "grounds"
const GROUP_BIRDS 	= "birds"

const MEDAL_BRONZ	= 10
const MEDAL_SILVER	= 20
const MEDAL_GOLD		= 30
const MEDAL_PLATINUM	= 50

static var score: int =0

static func add_score(points:int):
	score += points
