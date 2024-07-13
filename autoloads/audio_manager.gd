extends Node

@onready var tree := get_tree()

func play_sound3D(sound: AudioStream,randomize_pitch:=false,min_pitch := 0.9,max_pitch := 1.1, autoplay := true) ->AudioStreamPlayer3D:
	var player = AudioStreamPlayer3D.new()
	player.stream = sound
	player.autoplay = autoplay
	if randomize_pitch:
		player.pitch_scale = randf_range(min_pitch, max_pitch)
	player.finished.connect(func(): player.queue_free())
	tree.current_scene.add_child(player)
	return player
