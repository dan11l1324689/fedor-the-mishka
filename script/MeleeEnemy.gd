extends "res://script/AiEntity.gd"
class_name MeleeEnemy


var attack_timer := Timer.new()
export var attack_cooldown = 1

func process_chase():
	.process_chase()
	if position.distance_to(chase_target.position) < 10 and attack_timer.is_stopped():
		attack_timer.one_shot = true 
		deal_damage(chase_target, 2)
		attack_timer.start(attack_cooldown)
