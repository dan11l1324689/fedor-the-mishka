extends KinematicBody2D
func entity_HP_change(new_value):
	HP = clamp(new_value,0,max_HP)
class_name LivingEntity
export var HP:int=10
export var max_HP:int=10
export var gamemanager_notepath:NodePath
var gamemanager:GameManager
export var speed:float = 200
export var acceleration:float = 2000
var velocity:Vector2
func entity_calculate_target_velocity() ->Vector2:
	return Vector2()
func entity_move(target_vet:Vector2, delta:float):
	velocity = velocity.move_toward(target_vet,acceleration*delta)
	velocity = move_and_slide(velocity)
enum EntityState{
		INACTIVE = 1
		DEAD = 0,
		ALIVE = 2,
		PATROL = 3,
		CHASE = 4
}

export(EntityState) var state =EntityState.INACTIVE setget new_state
func new_state(new_value):
	state=new_value
func check_visual_contact(other:LivingEntity)->bool:
	var raycast=RayCast.new()
	gamemanager.add_chiic(raycast)
	raycast.cast_to=other.position - position
	raycast.position=position
	raycast.force_raycast_update()
	var return_olata:=raycast.get_collider() as LivingEntity == other
	raycast.queue_free()
	return return_olata
func _ready():
	pass
	gamemanager=get_node_or_null(gamemanager_notepath) as GameManager 
