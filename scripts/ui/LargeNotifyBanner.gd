extends ColorRect

onready var Env = get_node("/root/Env")
onready var Scene = get_node("/root/Scene")

var animation_name = "TurnChangeAnim"


func _ready():
	var gsm = Env.find_node_of_type(GameStateManager)
	gsm.connect("game_won", self, "_on_GamaeStateManager_game_won")
	
	set_animation_speed(0.25)
	
func play_animation(text, bg_color = Color.black):
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()

	color = bg_color
	$TurnChangeLabel.set_text(text)
	$AnimationPlayer.play(animation_name)

func set_animation_speed(speed: float): # speed in range (0, inf)
	$AnimationPlayer.set_speed_scale(speed)
	
func _on_GamaeStateManager_game_won():
	play_animation("Victory!", Color.green)
	Env.create_timer(self, 5).connect("timeout", self, "_on_Timer_timeout") 
	
func _on_Timer_timeout():
		Scene.load_scene("Overworld")