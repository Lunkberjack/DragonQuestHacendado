extends KinematicBody2D

const moveSpeed = 60
const maxSpeed = 80
const jumpHeight = -250
const up = Vector2(0, -1)
const gravity = 15

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

var motion = Vector2()

# Cambia el sprite al sprite de ataque y reproduce la animación al derecho y al revés
func play_attack(attack_name):
		$Sprite2.visible = true
		$Sprite.visible = false
		$AnimationPlayer2.play(attack_name)

func _physics_process(delta):
	motion.y += gravity
	var friction = false
	
	if Input.is_action_pressed("ui_right"):
		sprite.flip_h = false
		$Sprite2.flip_h = false
		animationPlayer.play("Walk")
		motion.x = max(motion.x - moveSpeed, maxSpeed)
		# Se puede atacar andando
		if Input.is_key_pressed(KEY_CONTROL):
			play_attack("Attack_special1")
		if Input.is_key_pressed(KEY_Z):
			play_attack("Attack_specialZ")
	elif Input.is_action_pressed("ui_left"):
		sprite.flip_h = true
		$Sprite2.flip_h = true
		animationPlayer.play("Walk")
		motion.x = max(motion.x - moveSpeed, -maxSpeed)
		# Se puede atacar andando
		if Input.is_key_pressed(KEY_CONTROL):
			play_attack("Attack_special1")
		if Input.is_key_pressed(KEY_Z):
			play_attack("Attack_specialZ")
	elif Input.is_key_pressed(KEY_CONTROL):
		play_attack("a")
	elif Input.is_key_pressed(KEY_Z):
		play_attack("Attack_specialZ")
	else:
		# El sprite de ataque se desactiva y se vuelve a activar el Idle
		$Sprite2.visible = false
		sprite.visible = true
		# Se reproduce la animación de estar parado y se para el movimiento
		animationPlayer.play("Idle")
		motion.x = 0
		
	if is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			motion.y = jumpHeight
		# Se puede atacar saltando, pero no ataques especiales
		# No, este ataque no es especial, cambiar el nombre
		if Input.is_key_pressed(KEY_CONTROL):
			play_attack("Attack_special1")
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.5)
	else:
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.01)
			
	motion = move_and_slide(motion, up)
