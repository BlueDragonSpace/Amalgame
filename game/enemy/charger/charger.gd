extends Enemy

@onready var Art: Sprite2D = $Derek
@onready var Animate: AnimationPlayer = $AnimationPlayer

@onready var ground_ray: ShapeCast2D = $GroundRay

@export var force_x: float = 0.0 #animated

var charge_direction = 1: #1 is right, -1 is left
	set(new_dir):
		if new_dir == 1:
			Art.flip_h = false
		else:
			Art.flip_h = true
		
		charge_direction = new_dir

var active = false #inactive until on screen

func _physics_process(_delta: float) -> void:
	if ground_ray.is_colliding() and active:
		apply_central_force(Vector2(force_x * charge_direction * 100,0))

func _on_reroute_timer_timeout() -> void:
	charge_direction = find_x_direction(Player)
	Animate.play("charge")


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	active = true
	
