extends CanvasLayer

signal start_HUD_appear
@onready var hp_bar: HBoxContainer = $Theme/HUD/HpBar

@onready var pause_screen: Control = $Theme/PauseScreen
var pausable = true #can go to pause screen

signal started
@onready var start_screen: Control = $Theme/StartScreen

@onready var death_screen: Control = $Theme/DeathScreen

@onready var Animate: AnimationPlayer = $AnimationPlayer

@onready var Player = get_tree().get_nodes_in_group("Player")[0]

var HP = preload("res://UI/hp.tscn")

var death_text = ["You have been\n is are now unalived", "Wow there are words here", "Hello, please take a number"]

func _ready() -> void:
	connect("start_HUD_appear", HUD_appear)
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
	
	if start_screen.visible and Input.is_action_just_pressed("unpause"):
		started.emit()
		Animate.play("start_fade")
	
	if death_screen.visible and Input.is_action_just_pressed("unpause"):
		get_tree().reload_current_scene()
		death_screen.visible = false

		Engine.time_scale = 1.0
		pausable = true


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
	

func HUD_appear() -> void:
	Animate.play("HUD_appear")

#unfortunately, I'm making this game to not have touch or mouse controls, 
func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()
	death_screen.visible = false

	Engine.time_scale = 1.0
	pausable = true

func _on_start_pressed() -> void:

	started.emit()
	Animate.play("start_fade")
