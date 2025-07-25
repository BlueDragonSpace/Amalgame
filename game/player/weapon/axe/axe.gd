extends RigidBody2D

#doo doot doo

func _on_hurtbox_body_entered(body:Node2D) -> void:
	body.take_hit(angular_velocity, self)
