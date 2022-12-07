extends KinematicBody

export(NodePath) var caminho_jogador = ""
export(NodePath) var caminho_navegador = ""
var jogador
var navegador : Navigation
var vetor_movimento = Vector3.ZERO
var gravidade = 15
var velocidade_y = 0.0
var velocidade = 2.5
var run = false

func _ready():
	jogador = get_node(caminho_jogador)
	navegador = get_node(caminho_navegador)
	pass

func _physics_process(delta):
	var aplicar_velocidade = velocidade
	run = false
	if translation.distance_to(jogador.translation) > 30 or Jogo.retornar_tempo() < 60:
		run = true
	if translation.distance_to(jogador.translation) < 2.5:
		get_tree().change_scene("res://Jogo-completo.tscn")
	if run:
		$AnimationTree["parameters/playback"].travel("Correndo")
		aplicar_velocidade = velocidade * 2
	else:
		$AnimationTree["parameters/playback"].travel("Andando")
	if is_on_floor():
		var path = navegador.get_simple_path(translation, jogador.translation)
		if path.size() > 2:
			vetor_movimento = translation.direction_to(path[2])
			vetor_movimento.y = 0
			look_at(translation + vetor_movimento, Vector3.UP)
			velocidade_y = 0
	else:
		velocidade_y -= gravidade * delta
	move_and_slide(vetor_movimento * aplicar_velocidade + Vector3(0, velocidade_y, 0), Vector3.UP)
	pass
