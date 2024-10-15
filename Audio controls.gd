extends HSlider


var MusicBusName: String = "Music"
var EffectBusName: String = "Effects"

@onready var MusicBus  := AudioServer.get_bus_index(MusicBusName)
@onready var EffectBus  := AudioServer.get_bus_index(EffectBusName)

func _ready() -> void:
	value = db_to_linear(AudioServer.get_bus_volume_db(MusicBus))
	value = db_to_linear(AudioServer.get_bus_volume_db(EffectBus))


func music_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MusicBus, linear_to_db(value))
	
func effect_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(EffectBus, linear_to_db(value))
