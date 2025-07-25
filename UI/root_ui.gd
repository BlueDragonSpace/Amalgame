extends CanvasLayer

@onready var hp_bar: HBoxContainer = $Theme/HpBar

@onready var pause_screen: Control = $Theme/PauseScreen
var pausable = true #can go to pause screen
@onready var death_screen: Control = $Theme/DeathScreen

@onready var Animate: AnimationPlayer = $AnimationPlayer

@onready var Player = get_tree().get_nodes_in_group("Player")[0]

var HP = preload("res://UI/hp.tscn")

var death_text = ["You have been\n is are now unalived", "Wow there are words here", "Hello, please take a number"]

func _ready() -> void:
	Player.connect("player_hit",change_hp)
	Player.connect("player_dead", player_death)
	death_screen.get_node("Label").text = death_text[randi_range(0,death_text.size()-1)]

func _process(delta: float) -> void:

	if pausable:
		if Input.is_action_just_pressed("pause"):
			pause_screen.visible = true
			get_tree().paused = true

		if Input.is_action_just_pressed("unpause") and get_tree().paused:
			pause_screen.visible = false
			get_tree().paused = false
		
	if Player.is_dead:
		Engine.time_scale -= 0.3 * delta

func change_hp() -> void:
	for child in hp_bar.get_children():
		child.queue_free()
	for num in Player.HP:
		var new_child = HP.instantiate()
		hp_bar.add_child(new_child)

func player_death() -> void:
	Animate.play("fade_to_death")
	death_screen.visible = true
	pausable = false
	

func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = 1.0
	pausable = true
