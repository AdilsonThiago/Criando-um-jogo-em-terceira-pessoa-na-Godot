extends KinematicBody

var velocidade_movimento = 2.5
var gravidade = 15
var velocidade_y = 0.0
var velocidade_pulo = 13
var vetor_movimento = Vector3(0, 0, 0)
var sensibilidade_mouse = 0.3
var correndo = false

onready var anim_tree = $AnimationTree
onready var anim_playback = anim_tree.get("parameters/playback")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event):
	if event.is_action_pressed("b_sair"):
		get_tree().quit()
	if event is InputEventMouseMotion:
		rotate_y(- deg2rad(event.relative.x) * sensibilidade_mouse)
		$AncoraCam.rotate_x(- deg2rad(event.relative.y) * sensibilidade_mouse)
		$AncoraCam.rotation.x = clamp($AncoraCam.rotation.x, deg2rad(-70), deg2rad(70))
	if event.is_action_pressed("b_correr"):
		correndo = not correndo
	pass

func _physics_process(delta):
	if is_on_floor():
		var andando = false
		var frente = 1
		var permitir_velocidade = velocidade_movimento
		vetor_movimento = Vector3(0, 0, 0)
		anim_tree["parameters/Andando/blend_position"] = Vector2(0, 0)
		anim_tree["parameters/Correndo/blend_position"] = Vector2(0, 0)
		velocidade_y = 0
		
		if Input.is_action_pressed("b_frente"):
			vetor_movimento -= transform.basis.z
			anim_tree["parameters/Andando/blend_position"] += Vector2(0, 1)
			anim_tree["parameters/Correndo/blend_position"] += Vector2(0, 1)
			andando = true
		elif Input.is_action_pressed("b_atras"):
			vetor_movimento += transform.basis.z
			anim_tree["parameters/Andando/blend_position"] += Vector2(0, -1)
			anim_tree["parameters/Correndo/blend_position"] += Vector2(0, -1)
			andando = true
			frente = -1
		if Input.is_action_pressed("b_direita"):
			vetor_movimento += transform.basis.x
			anim_tree["parameters/Andando/blend_position"] += Vector2(1, 0) * frente
			anim_tree["parameters/Correndo/blend_position"] += Vector2(1, 0) * frente
			andando = true
		elif Input.is_action_pressed("b_esquerda"):
			vetor_movimento -= transform.basis.x
			anim_tree["parameters/Andando/blend_position"] += Vector2(-1, 0) * frente
			anim_tree["parameters/Correndo/blend_position"] += Vector2(-1, 0) * frente
			andando = true
		
		if andando and correndo:
			permitir_velocidade = velocidade_movimento * 2
			anim_playback.travel("Correndo")
		elif andando:
			anim_playback.travel("Andando")
		else:
			anim_playback.travel("Parada")
		
		vetor_movimento = vetor_movimento.normalized() * permitir_velocidade
	else:
		velocidade_y -= gravidade * delta
	move_and_slide(vetor_movimento + Vector3(0, velocidade_y, 0), Vector3.UP)
	pass
