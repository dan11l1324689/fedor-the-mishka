extends AiEntity
class_name RangedEnemy

var attack_timer := Timer.new()
export var attack_cooldown = 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(attack_timer)

func process_chase():
	.process_chase()
	if can_see(chase_target) and position.distance_to(chase_target.position) < 200 and attack_timer.is_stopped():
		attack_timer.one_shot = true
		attack_timer.start(attack_cooldown)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func target_entity_position(entity:LivingEntity)->Vector2:
	return entity.position.direction_to(position) * 100 + entity.position
	
