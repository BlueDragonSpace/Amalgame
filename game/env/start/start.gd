extends Node2D

@onready var UI = get_tree().get_nodes_in_group("UI")[0]
@onready var Cameras = get_tree().get_nodes_in_group("Player")[1]

@onready var Box: StaticBody2D = $startBox

@onready var FallSound: AudioStreamPlayer = $WhistleDown
@onready var PoundSound: AudioStreamPlayer = $startPound/HitGround

func _ready() -> void:
	UI.connect("started",Box.queue_free)
	UI.connect("started",FallSound.play)

func _on_start_pound_body_entered(body:Node2D) -> void:

	if PoundSound.playing == false:
			
		#assuming this is player... that's what the layers are configured to
		body.pound()
		Cameras.get_child(0).enabled = false
		UI.Animate.play("HUD_appear")

		PoundSound.play()


func _on_hit_ground_finished() -> void:
	queue_free()
