extends CanvasLayer

func _process(delta):
	var tempo_restante = Jogo.retornar_tempo()
	$Label.text = "Tempo restante: " + str(floor(tempo_restante))
	pass
