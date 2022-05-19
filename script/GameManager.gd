
extends Node
class_name GameManager

var player : KinematicBody2D
var entities := []

export (NodePath) var navnode : NodePath

func _ready():
	$"/root/GlobalManager".gamemanager = self
	update_entity_list()

func update_entity_list()->void:
	entities = []
	for node in get_children():
		if node is LivingEntity:
			register_entity(node as LivingEntity)

func select_target(entity : LivingEntity) -> LivingEntity:
	update_entity_list()
	var target : LivingEntity
	var best_distance : float = INF
	for other in entities:
		if other is LivingEntity:
			if entity.is_enemy(other):
				if entity.can_see(other):
					var distance = entity.position.distance_to(other.position)
					if best_distance > distance:
						target = other
						best_distance = distance
	return target

func register_entity(entity : LivingEntity) -> void:
	if entity and not entities.has(entity):
		entities.append(entity)
		if entity is Player:
			player = entity

func get_navpath(start : Vector2, target : Vector2) -> PoolVector2Array:
	#var navigation := get_node_or_null(navnode) as Navigation2D
	var navigation = $Navigation2D
	return navigation.get_simple_path(start, target, true) if navigation else PoolVector2Array()

func restart_level():
	get_tree().reload_current_scene()
