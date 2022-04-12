extends Node
onready var navigation:Navigation2D=$Navigation
func register_entity(entity : LivingEntity) -> void:
	if entity and not entities.has(entity):
		entities.append(entity)

var player:KinematicBody2D
class_name GameManager
func get_navpath(a,b):
	return navigation.get_simple_path(a,b)
var entities := []
func update_entity_list()->void:
	entities = []
	for node in get_children():
		if node is LivingEntity:
			register_entity(node as LivingEntity)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/GlobalManager".gamemanager= self
	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
