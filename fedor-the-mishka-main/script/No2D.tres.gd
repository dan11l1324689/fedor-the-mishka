extends KinematicBody2D


var respawn_point = Vector2() # переменная для точки респавна врага
var active = false # увидел ли враг игрока?
var dead = false # мертв ли враг?

func _ready():
	respawn_point = position # запоминаем точку респавна

func _physics_process(delta):
	var player = $"/root/Global".player as KinematicBody2D
	if player: #получаем игрока
		if active and not dead: # если враг активен и не мертв
			look_at(player.global_position) # поворачиваем в сторону игрока
			move_and_slide(position.direction_to(player.position)*1000*delta) # двигаем в сторону игрока
			if position.distance_to(player.position) < 8: # если игрок слишком близко
				get_tree().reload_current_scene() # перезапускаем уровень (смерть)
		else: # если враг не активен
			active = $VisibilityNotifier2D.is_on_screen() # отслеживаем видимость врага на экране игрока

func dead(): # когда враг убит
	dead = true
	$respawn_timer.start() # вкючаем таймер респавна
	$Sprite.visible = false # прячем врага
	$CollisionShape2D.disabled = true # выключаем коллизию

func respawn_timeout(): # когда враг респавнится
	dead = false 
	active = false # снова деактивируемся
	position = respawn_point # перемещаемся на точку респавна
	$Sprite.visible = true # показываем врага
	$CollisionShape2D.disabled = false # включаем коллизию
