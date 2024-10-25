extends Node

class_name PointsCounter

signal on_points_increased(points: int)

var points = 0

@onready var invader_spawner = $"../InvaderSpawner" as InvaderSpawner

func _ready():
	Globals.time_bonus = 300
	invader_spawner.invader_destroyed.connect(increase_points)

func _process(delta: float):
	if(Globals.player_alive):
		if(Globals.time_bonus > 0):
			Globals.time_bonus -= delta/2
		elif(Globals.time_bonus <0):
			Globals.time_bonus = 0

func increase_points(points_to_add: int):
	points += points_to_add
	on_points_increased.emit(points)
	Globals.score = points
