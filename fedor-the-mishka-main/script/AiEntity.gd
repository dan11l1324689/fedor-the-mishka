extends LivingEntity
class_name AiEntity
export var visibilty:NodePath 
var chase_target 
var chase_timeout_time
var patrol
var target=Vector2()
var chase_timeout_timer
func update_target():
	pass
func update_final(_final):
	pass
func _physics_process(delta):
	match state:
		EntityState.INACTIVE:
			process_inactive()
		EntityState.PATROL:
			process_patrol()
		EntityState.ALIVE:
			process_alive()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func process_inactive():
	var v =get_node_or_null (visibilty)as VisibilityNotifier2D
	pass
	if v.is_on_screen():
		new_state(EntityState.PATROL)
func update_patrol_target():
	var pre_target = patrol


func process_alive():
	pass

func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func process_patrol():
	if check_visual_contact(gamemanager.player):
		new_state(EntityState.CHASE)
		chase_target = gamemanager.player
		
#нада заполниять  process_chase()
func target_entity_position(entity : LivingEntity)-> Vector2:
	return entity.position 
func update_patrol_target():
	var pre_target := partol_position + Vector2(rand_range(0, patrol_max_dis)
func process_chase():
	update_final (target_entity_position(chase_target))
	update_target()
	var new_chase_target_visibility : bool = check_visual_contact(chase_target)
	if new_chase_target_visibility and not new_chase_target_visibility and chase_timeout_time != -1:
		chase_timeout_timer.start(max(chase_timeout_time, 0))
	elif new_chase_target_visibility:
		pass

func chase_timeout():
		chase_timeout_timer.stop()
