extends Entity

@export var speed: float = 400.0

@onready var weapon_hold: Node2D = $WeaponHold
@onready var weapon_animation: AnimationPlayer = $WeaponHold/Axe/AnimationPlayer



func _process(_delta: float) -> void:

	#WEAPON LOGIC
	weapon_hold.rotation = position.angle_to_point(get_global_mouse_position())

	if Input.is_action_just_pressed("attack"):
		weapon_animation.play("attack")
		
func _physics_process(_delta: float) -> void:

	#will likely end up taking this out

	#MOVEMENT LOGIC
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
