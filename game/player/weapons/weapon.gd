class_name Weapon
extends Area2D

@export var damage: int = 10
@export var knockback: float = 400.0
@export var active_weapon: bool = false #when the weapon is at the correct part of animation

var damage_bubble = preload("res://game/entity/damage_bubble.tscn")

func give_hit(body: Entity) -> void:

	var current_damage = damage
	var current_knockback = knockback

	if not active_weapon:
		current_damage *= 0.2
		current_damage = round(current_damage)
		current_knockback *= 0.2


	body.take_hit(current_damage)

	#knockback type: in direction of holding the weapon (not great, but prototype)

	#ALSO velocity_offset is only applicable for enemies... meaning that
	#THIS LINE WILL LIKELY BREAK THE CODE
	body.velocity_offset = Vector2(current_knockback, 0).rotated(get_parent().rotation)

	var bubble = damage_bubble.instantiate()
	bubble.text = str(round(current_damage))
	#make the bubble have global position, rather than attached to axe
	
	get_parent().get_node("Notif").add_child(bubble)
	bubble.position = body.global_position
	#bubble.scale = current_damage / 2.0

#all weapons should also have an attack animation in an AnimationPlayer...

func _get_configuration_warnings():
	var warnings = []
	
	if $AnimationPlayer:
		if not $AnimationPlayer.has_animation("attack"):
			warnings.append("Weapon must have an 'attack' animation in AnimationPlayer.")
	else: 
		warnings.append("Weapon must have an AnimationPlayer node with an 'attack' animation.")
	return warnings
