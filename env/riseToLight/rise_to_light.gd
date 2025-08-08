extends AnimatableBody2D

@onready var Particles: Node2D = $tooManyParticles
@onready var Animate: AnimationPlayer = $AnimationPlayer

@onready var PlayerCamera = get_tree().get_nodes_in_group("Player")[1]

func _on_activation_area_body_entered(_body:Node2D) -> void:
	Animate.play("rise_to_light")

	for child in PlayerCamera.get_children():
		if child.name == "EndCamera":
			child.enabled = true
		else:
			child.enabled = false
	

func play_particles() -> void:
	for child in Particles.get_children():
		child.emitting = true

#kills the player if they go on the non-moving platform, how else is the player supposed to get up?
func _on_platform_death_body_entered(body:Node2D) -> void: 
	body.is_dead = true

func _on_end_area_body_entered(_body:Node2D) -> void:
	print("end game here")
