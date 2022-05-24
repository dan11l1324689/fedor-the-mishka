extends LivingEntity
class_name AiEntity

export var patrol_max_distance : int = 90
export var chase_timeout_time : int = 0.2

var chase_target : LivingEntity
var chase_target_visibility : bool = false
var final_target : Vector2
var path := PoolVector2Array()
var patrol_position : Vector2
var patrol_timeout_timer := Timer.new()
var target : Vector2
var chase_timeout_timer := Timer.new()

export var visibility : NodePath

func _ready():
	chase_timeout_timer.connect("timeout", self, "chase_timeout")
	add_child(chase_timeout_timer)
	patrol_timeout_timer.connect("timeout", self, "update_patrol_target")
	add_child(patrol_timeout_timer)

func update_final_target(new_value:Vector2):
	final_target = new_value
	update_path($"/root/GlobalManager".gamemanager.get_navpath(position, final_target))

func update_path(new_value:PoolVector2Array):
	new_value.remove(0)
	path = new_value
	update_target()

func update_target():
	if path.size() <= 1:
		target = final_target
	else:
		if path[0].distance_to(position) < speed/60:
			path.remove(0)
		target = path[0]

func entity_calculate_target_velocity() -> Vector2:
	var dist = position.distance_to(target)
	var vel = position.direction_to(target)* min(speed, dist*10)
	look_at(target)
	return vel

func _physics_process(delta : float):

	match state:
		EntityState.INACTIVE:
			process_inactive()
		EntityState.PATROL:
			process_patrol()
		EntityState.CHASE:
			process_chase()
		EntityState.ALIVE:
			process_alive()
			

func process_inactive():
	target = position
	if get_node(visibility) and (get_node(visibility) as VisibilityNotifier2D).is_on_screen():
		new_state(EntityState.PATROL)
#=======
func process_patrol():
	var target_candidate = $"/root/GlobalManager".gamemanager.select_target(self)
	if target_candidate:
		new_state(EntityState.CHASE)
		chase_target = target_candidate

func update_patrol_target():
	var pre_target := patrol_position + Vector2(rand_range(0, patrol_max_distance), 0).rotated(deg2rad(rand_range(0, 360)))
	update_final_target(($"/root/GlobalManager".gamemanager.get_node($"/root/GlobalManager".gamemanager.navnode) as Navigation2D).get_closest_point(pre_target))
	
	patrol_timeout_timer.start(15)

#========
func target_entity_position(entity : LivingEntity)-> Vector2:
	return entity.position

func process_chase():
	update_final_target(target_entity_position(chase_target))
	update_target()
	chase_target_visibility = can_see(chase_target)
	if chase_timeout_timer.is_stopped() and not chase_target_visibility and chase_timeout_time != -1:
		chase_timeout_timer.start(max(chase_timeout_time, 0))
	elif chase_target_visibility:
		chase_timeout_timer.stop()

func chase_timeout():
	chase_timeout_timer.stop()
	if not can_see(chase_target):
		new_state(EntityState.PATROL)

func process_alive():
	new_state(EntityState.INACTIVE)

func new_state(new_value):
	.new_state(new_value)
	if new_value == EntityState.PATROL:
		patrol_position = position
		patrol_timeout_timer.start(15)
		#update_patrol_target()
	elif new_value != EntityState.PATROL:
		patrol_timeout_timer.stop()
	

