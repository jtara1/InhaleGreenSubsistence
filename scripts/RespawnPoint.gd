extends Node2D

const group_name = "RespawnPoints"

export(bool) var is_current_spawn_point = false
export(bool) var flip_horizontally = false

const CharacterNode = preload("res://game-objects/Character.tscn")

onready var Env = get_node("/root/Env")

onready var root = $"../"


func _ready():
	listen_to_character_dying_event()
	add_to_group(group_name)
	
	$Sprite.flip_h = flip_horizontally

func spawn_character():
	# clear the dying char name
	var dead_character = Env.get_character()
	dead_character.set_name("DeadCharacter")
	
	# create a new char & update its cache
	var character = CharacterNode.instance()
	Env.set_character(character)
	
	# update the new char position & name
	character.position = $PointToSpawnAt.global_position
	root.add_child(character) # add to scene tree
	
	character.respawned({"body_size": dead_character.body_size})
	character.set_name("Character")
	
	alert_all_to_relisten() # reconnect

func get_spawners():
	return get_tree().get_nodes_in_group(group_name)

func listen_to_character_dying_event():
	Env.get_character().connect("character_died", self, "_on_Character_character_died")
	
func alert_all_to_relisten():
	for spawner in get_spawners():
		spawner.listen_to_character_dying_event()
	
func disable_other_spawns():
	for spawner in get_spawners():
		if spawner != self:
			spawner.get_node("Sprite/RespawnPointAnimationPlayer").play("idle") # red flag
			spawner.is_current_spawn_point = false

func _on_Character_character_died():
	if is_current_spawn_point:
		spawn_character()

func _on_RespawnPoint_body_entered(body):
	if body is Character:
		is_current_spawn_point = true
		body.dashes_remaining = body.initial_dashes
		body.emit_signal("dashed", body.dashes_remaining)
		$Sprite/RespawnPointAnimationPlayer.play("idle2") # blue flag
		disable_other_spawns()

