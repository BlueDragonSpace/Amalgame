extends Weapon

#hmmmmm, if only I could put this part of the code in weapon.gd...
#then I would have no script needed for each individual weapon...

func _on_body_entered(body:Node2D) -> void:
	if body is Entity:
		give_hit(body)
