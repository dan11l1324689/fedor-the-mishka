extends LivingEntity
class_name Player

#var gamemanager : GameManager
#var weapon : BaseWeapon
func _ready():
	
	#print($"/root/GlobalManager".gamemanager)
	#$"/root/GlobalManager".gamemanager.player = self
	pass

func entity_calculate_target_velocity() -> Vector2:
	return speed * Input.get_vector("left", "right", "up", "down")*(Input.get_action_strength("run")/2+1)

func _physics_process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("shoot"):
		var object = $shoot_ray.get_collider() as Node2D
		if object and object is LivingEntity and is_enemy(object):
			deal_damage(object as LivingEntity, 10)


func death():
	$"/root/GlobalManager".gamemanager.restart_level()



