extends LivingEntity
class_name AiEntity
export var visibilty:NodePath 
var chase_target 
var target=Vector2()
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

func process_shase():
	update_final (target_entity_position(chase_target))
	update_target()
	var new_chase_state 
