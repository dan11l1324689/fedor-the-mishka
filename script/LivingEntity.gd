extends KinematicBody
func entity_HP_change(new_value):
	HP = clamp(new_value,0,max_HP)
class_name LivingEntity
export var HP:int=10
export var max_HP:int=10
