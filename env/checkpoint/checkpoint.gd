extends Area2D

@onready var sound: AudioStreamPlayer = $Checkpoint
@onready var Animate: AnimationPlayer = $AnimationPlayer

@export var active = false

@onready var PlayerNodes = get_tree().get_nodes_in_group("Player")
@onready var UI = get_tree().get_nodes_in_group("UI")[0]

func _ready() -> void:
	if active:
		PlayerNodes[0].global_position = global_position
		PlayerNodes[1].get_node("StartCamera").enabled = false
		UI.started.emit()

		Animate.play("light", -1, 100.0)

		set_active()
	


func _on_body_entered(_body:Node2D) -> void:
	if not active:
		set_active()
		sound.play()
		Animate.play("light")

func set_active() -> void:

	PlayerNodes[0].HP = PlayerNodes[0].max_HP

	active = true
	Global.checkpoint_pos = self.global_position
