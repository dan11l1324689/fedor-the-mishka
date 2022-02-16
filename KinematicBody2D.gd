extends KinematicBody2D


func _physics_process(delta):
	var player = $"/root/Global".player as KinematicBody2D
	if player:
		look_at(player.global_position)
		move_and_slide((player.global_position - global_position).normalized()*3000*delta)
		pass
	pass
 



func _ready():
	pass 

