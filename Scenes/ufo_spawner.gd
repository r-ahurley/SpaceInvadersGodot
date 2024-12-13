extends Node2D

signal ufo_destroyed(points: int)

@onready var ufo_spawn_timer = $SpawnTimer
@export var ufo_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	(ufo_spawn_timer as SpawnTimer).setup_timer()


func _on_spawn_timer_timeout():
	var ufo = ufo_scene.instantiate() as Ufo
	ufo.global_position = position
	ufo.on_ufo_destroyed.connect(on_ufo_destroyed)
	get_tree().root.add_child(ufo)
	

func on_ufo_destroyed(points: int):
	ufo_destroyed.emit(100)

func _on_ui_game_over() -> void:
	ufo_spawn_timer.stop()
	
