extends Label

# I think the logic behind damage bubble being in Entities despite not being an Entity
# Is since these only apply to Entities (at least at the time of writing)

#position offset is exported to be adjusted by AnimationPlayer
@export var position_offset: Vector2 = Vector2(0, 0)

func _process(_delta: float) -> void:
	position = position + position_offset
