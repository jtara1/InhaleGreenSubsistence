extends "res://scripts/GameObject.gd"
class_name SpaceShip

export(Vector2) var acceleration = Vector2(0, -0.3)
export(bool) var is_lifting_off = false

onready var Env = get_node("/root/Env")
onready var game_manager = Env.find_node_of_type(GameStateManager)


func _ready():
	._ready()
	gravity = 0
	game_manager.connect("game_won", self, "_on_GameStateManager_game_won")

func _physics_process(delta):
	if is_lifting_off:
		._physics_process(delta)
		velocity += acceleration
	
func lift_off():
	is_lifting_off = true
	$AudioStreamPlayer2D.play()
	$AnimationPlayer.play("launch")
	$Sprite/FireSprite.visible = true
	
func _on_SpaceShip_body_entered(body):
	if body is Agent:
		game_manager.win_the_game()

func _on_GameStateManager_game_won():
	lift_off()