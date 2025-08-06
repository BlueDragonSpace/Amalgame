extends Area2D

@onready var light: Light2D = $PointLight2D
@export var on_color = Color(255,20,10)

@onready var sound: AudioStreamPlayer = $Checkpoint

@export var active = false

@onready var PlayerNodes = get_tree().get_nodes_in_group("Player")
@onready var UI = get_tree().get_nodes_in_group("UI")[0]

func _ready() -> void:
	if active:
		PlayerNodes[0].global_position = global_position
		PlayerNodes[1].get_node("StartCamera").enabled = false
		UI.started.emit()

		set_active()
	


func _on_body_entered(_body:Node2D) -> void:
	if not active:
		set_active()
		sound.play()

func set_active() -> void:
	active = true
	light.color = on_color
	Global.checkpoint_pos = self.global_position
