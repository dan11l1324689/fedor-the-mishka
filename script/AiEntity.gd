extends LivingEntity
class_name AiEntity
export var visibilty:NodePath 
var gamemanager
var target=Vector2()
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
	pass

func process_patrol():
	pass

func process_alive():
	pass

func _ready():
	pass # Replace with function body.

var v =get_node_or_null (visibilty)as VisibilityNotifier2D
	if v.is_on_screen():
		new_state(Entity.PATROL)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
