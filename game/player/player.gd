extends RigidBody2D

@onready var oof: AudioStreamPlayer2D = $oof

@onready var left_ray: RayCast2D = $left_ray
@onready var right_ray: RayCast2D = $right_ray

@onready var Weapon: PhysicsBody2D = $axe
var has_weapon = true

@export var STR: float = 170.0 #how powerfully you can swing your weapon
@export var MAX_SWING : float = 25.0 #how fast you can swing at max (and in turn, max damage)

const SPEED = 10000.0 #really high speed, trying to bypass axe weight
const MAX_SPEED = 1200.0 #max speed... on ground

var weapon_angular_velocity: float = 0.0

func _physics_process(delta: float) -> void:
	
	#MOVEMENT
	var direction := Input.get_axis("move_left", "move_right")

	if left_ray.is_colliding():
		direction = clamp(direction, 0.0, 1.0)
	elif right_ray.is_colliding():
		direction = clamp(direction, -1.0, 0.0)

	if direction:
		linear_velocity.x += direction * SPEED * delta
		linear_velocity.x = clamp(linear_velocity.x,-MAX_SPEED, MAX_SPEED)
	elif get_contact_count() > 0:
		linear_velocity.x = move_toward(linear_velocity.x, 0, abs(linear_velocity.x) * 0.25)

	#WEAPON MANAGEMENT
	if has_weapon:
		if Input.is_action_pressed("weapon_left"):
			Weapon.angular_velocity -= STR  * delta
		elif Input.is_action_pressed("weapon_right"):
			Weapon.angular_velocity += STR * delta
		else:
			Weapon.angular_velocity = move_toward(Weapon.angular_velocity, 0, 105.0 * delta)
		Weapon.angular_velocity = clamp(Weapon.angular_velocity, -MAX_SWING, MAX_SWING)
		
	#reset position
	if Input.is_action_just_pressed("debug3"):
		global_position = Vector2(0,0)


func _on_body_entered(body:Node) -> void:
	if body.name == "Enemy":
		oof.play()

	
