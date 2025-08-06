extends RigidBody2D

@onready var HitAudio: AudioStreamPlayer = $Axehit
@onready var Camera: Node2D = get_tree().get_nodes_in_group("Player")[1]


func get_custom_tile_data(body_rid: RID, tilemap: Node2D, data_layer_name: String):
	if tilemap is TileMap:
		var tile_cord = tilemap.get_coords_for_body_rid(body_rid)
		var tile = tilemap.get_cell_tile_data(0, tile_cord)
		return tile.get_custom_data(data_layer_name)
	else:
		return null



func _on_hurtbox_body_shape_entered(_body_rid:RID, body:Node, _body_shape_index:int, _local_shape_index:int) -> void:

	if body is RigidBody2D:

		Camera.screenshake(angular_velocity * 2, 0.2)

		#DAMAGE Calculations
		var damage = angular_velocity
		damage = abs(damage)

		#additional damage based on mass and speed of enemy colliding with weapon
		# say a 0.5 spring collided with axe at (300, 2200) velocity [forward, downward]
		# I want 300^2 + 2200^2 = c^2, c * .5, divide by 100 is the damage

		var added_damage = (body.linear_velocity.x * body.linear_velocity.x) \
		+ (body.linear_velocity.y * body.linear_velocity.y)

		added_damage = sqrt(added_damage) #Pythagorean Theorem
		added_damage *= body.mass #more mass, more damage
		added_damage /= 100.0 #Divide by 100 for good measure
		round(added_damage) # no decimal damage

		added_damage = clamp(added_damage,0,10) #max of 10 damage

		@warning_ignore("narrowing_conversion")
		damage += added_damage
		
		body.take_hit(damage, self)

		#AUDIO
		if body.Armor > damage:
			HitAudio = $ArmorHitCrushed
		else:
			HitAudio = $Axehit

		HitAudio.pitch_scale = randi_range(0,3) * 0.25 + 0.5
		HitAudio.play()
	else:
		$AxeGround.play()
