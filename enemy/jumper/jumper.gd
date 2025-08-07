extends Enemy

@onready var Animate: AnimationPlayer = $AnimationPlayer
@onready var ground_ray: ShapeCast2D = $GroundRay
@onready var JumpTimer: Timer= $JumpTimer

@export var air_control = 20000.0
@export var jump_height = 1250.0

var active = false

func _physics_process(delta: float) -> void:
	if active:
		if not ground_ray.is_colliding():

			var direction = Player.global_position - global_position
			direction = direction.normalized()

			apply_central_force(direction * air_control * delta)
		elif JumpTimer.time_left == 0:
			JumpTimer.start()
	

func _on_timer_timeout() -> void:
	Animate.play("compression")

func mid_compress():
	if active:
		if ground_ray.is_colliding():
			apply_impulse(Vector2(0, -jump_height))
			$SpringJump.play()
	
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	active = true
