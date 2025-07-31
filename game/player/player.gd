extends RigidBody2D


@onready var oof: AudioStreamPlayer2D = $oof

@onready var left_ray: RayCast2D = $left_ray
@onready var right_ray: RayCast2D = $right_ray

@onready var Weapon: PhysicsBody2D = $axe
var has_weapon = true

@export var STR: float = 170.0 #how powerfully you can swing your weapon
@export var MAX_SWING : float = 25.0 #how fast you can swing at max (and in turn, max damage)

@onready var Camera: Node2D = get_tree().get_nodes_in_group("Player")[1]

@onready var PoundParticles: GPUParticles2D = $PoundParticles
@onready var Animate: AnimationPlayer = $AnimationPlayer

signal player_hit
@export var HP: int = 5: #hphphphphphphhphphphphphphph
	set(new_hp):
		HP = new_hp
		player_hit.emit()
@export var invincible = false #gets animated
@export var in_control = false #no control while invincible or dead
@export var dev_inv = false #true invincibility, for me the dev

signal player_dead
var is_dead = false: #bleh death
	set(new_dead):
		if is_dead != new_dead and new_dead: #makes sure player_dead only emits once
			player_dead.emit() 
		is_dead = new_dead

const SPEED = 20000.0 #really high speed, trying to bypass axe weight
const MAX_SPEED = 1600.0 #max speed... on ground

var weapon_angular_velocity: float = 0.0
var facing_dir: String = 'neutral' #should be enum, 'neutral', 'left', 'right'

func _physics_process(delta: float) -> void:
	
	#MOVEMENT
	var direction := Input.get_axis("move_left", "move_right")

	if left_ray.is_colliding():
		direction = clamp(direction, 0.0, 1.0)
	elif right_ray.is_colliding():
		direction = clamp(direction, -1.0, 0.0)

	if direction:

		if direction > 0:
			facing_dir = 'right'
		elif direction < 0:
			facing_dir = 'left'
		else:
			facing_dir = 'neutral'

		if in_control: #Can't control own direction. Can stll control the axe tho
			linear_velocity.x += direction * SPEED * delta
		linear_velocity.x = clamp(linear_velocity.x,-MAX_SPEED, MAX_SPEED)
	elif get_contact_count() > 0:
		linear_velocity.x = move_toward(linear_velocity.x, 0, abs(linear_velocity.x) * 0.25)

	#WEAPON MANAGEMENT
	if has_weapon and in_control:
		if Input.is_action_pressed("weapon_left"):
			Weapon.angular_velocity -= STR  * delta
		elif Input.is_action_pressed("weapon_right"):
			Weapon.angular_velocity += STR * delta
		else:
			Weapon.angular_velocity = move_toward(Weapon.angular_velocity, 0, 105.0 * delta)
		Weapon.angular_velocity = clamp(Weapon.angular_velocity, -MAX_SWING, MAX_SWING)
		
	#reset position
	if Input.is_action_just_pressed("debug3"):
		global_position = Vector2(4500,-1200)
	if Input.is_action_just_pressed("debug4"):
		player_take_hit(self)

func _on_body_entered(body: Node) -> void:
	if body is Enemy and not invincible and not dev_inv:
		player_take_hit(body)

func player_take_hit(body: Node) -> void:

	oof.play()

	if HP > 1:

		Animate.play("flinch")
		Camera.screenshake(32, 0.7)

		var dir = body.global_position - global_position
		dir = dir.normalized()

		dir.y += -0.125 #gains an upward tilt
		dir.x = -dir.x #away from the enemy
		dir.x *= 3 #farther away from enemy

		linear_velocity += dir * 4000.0
	else:
		is_dead = true
		in_control = false

	HP -= 1

func pound() -> void:
	PoundParticles.emitting = true
	Camera.screenshake(4,0.2)