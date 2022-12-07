extends Node

var tempo = 60 * 3

func _process(delta):
	tempo -= delta
	if tempo <= 0:
		get_tree().change_scene("res://Jogo-completo.tscn")
	pass

func retornar_tempo():
	return tempo
	pass
