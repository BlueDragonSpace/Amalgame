extends Enemy

@export var rope_length = 384.0
@export var impulse_str = 2700.0
@export var point_spd = 128.0

@onready var SwingPoint: StaticBody2D = self.get_parent().get_parent()

var active = false

func _ready() -> void:

	#sets the Swinger's position from rope
	self.position = SwingPoint.global_position
	self.position += Vector2(0,rope_length)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if active:

		var dir = Player.global_position - global_position
		dir = dir.normalized()

		#moves the peak of pendulum
		SwingPoint.position.x += delta * point_spd * Helper.is_positive(dir.x)

		# Impulses Swinger towards player
		apply_central_impulse(dir * impulse_str * delta)
		


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	active = true
