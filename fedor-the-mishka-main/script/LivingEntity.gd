extends KinematicBody2D
class_name LivingEntity
# класс живой сущности
# + имеет здоровье, может получать урон, умирать и возраждаться
# + имеет способность к движению
# + может наносить урон
# - не имеет ИИ или контроля игроком

# ===== здоровье
export var max_HP : int = 10               # максимальное количество здоровья
export var HP : int = 10 setget entity_HP_changed # текущее количество здоровья
export var respawn_timeout : float = -1 # время, через которое сущность возрадится (-1 - отключить возраждение, 0 - мгновенное возраждение)

signal HP_changed(old_value, new_value)
# что-то поменяло здоровье сущности...
func entity_HP_changed(new_value : int):
	if self.state != EntityState.DEAD: # если сущность жива, то меняем хп. иначе никак
		var new_HP = clamp(new_value, 0, max_HP)
		emit_signal("HP_changed", HP, new_HP)
		HP = new_HP
		if new_value == 0:
			new_state(EntityState.DEAD)

signal damage_dealt(target, damage)

func deal_damage(target : LivingEntity, damage : int):
	if target:
		target.HP -= damage
		emit_signal("damage_dealt", target, damage)

# ===== состояния
enum EntityState{ # возможные состояния сущности
		INACTIVE = 0, # неактивна (стоит на месте и не двигается)
		PATROL = 1, # патрулирует (ходит вокруг фиксированной точки)
		CHASE = 2, # преследования (преследует указанную сущность)
		DEAD = 3, # мертва (не видна, не двигается, не активируется)
		ALIVE = 4, # сущность жива, но не имеет ни одного из состояний выше
}
export (EntityState) var state = EntityState.INACTIVE setget new_state# состояние сущности

signal state_changed(old_state, new_state)

func new_state(new_value):
	emit_signal("state_changed", state, new_value)
	state = new_value
	match new_value:
		EntityState.ALIVE:
			rebirth()
		EntityState.DEAD:
			death()

func death():
	if respawn_timeout == -1: # возрождение отключено, просто удаляем узел сущности
		self.queue_free()
	elif respawn_timeout <= 0: # установлено некорректное либо нулевое время респавна, респавнимся сразу
		new_state(EntityState.ALIVE)
	else: # если возрождение включено и все корректно установлено, то ждем и респавнимся
		var timer := Timer.new()
		timer.connect("timeout", self, "new_state", [EntityState.ALIVE])
		timer.connect("timeout", timer, "queue_free")
		timer.one_shot = true
		timer.start(respawn_timeout)
# &
func rebirth():
	entity_HP_changed(max_HP)
# - Lotus Eater

# ===== движение
export var speed : float = 200       # скорость сущности, в пикселях в секунду
var velocity : Vector2        # сколько пикселей прошла сущность за прошлый кадр
export var acceleration : float = 2000 # ускорение сущности, в пикселях в секунду в секунду

# функция для расчета скорости движения сущности
func entity_calculate_target_velocity() -> Vector2:
	return Vector2()

# функция для осуществления движения
func entity_move(targetvel : Vector2, frame_delta : float):
	velocity = velocity.move_toward(targetvel, min(acceleration * frame_delta, velocity.distance_to(targetvel))) # применяем ускорение
	velocity = move_and_slide(velocity) # двигаемся

func process_movement(delta : float):
	entity_move(entity_calculate_target_velocity(), delta)

# ===== фракции

enum EntityFactions {
		NEUTRAL = 0,
		FRIENDLY = 1,
		ENEMY = 2,
}
export (EntityFactions) var faction : int

func is_enemy(other : LivingEntity)->bool:
	if other.faction == EntityFactions.NEUTRAL or faction == EntityFactions.NEUTRAL:
		return false
	else:
		return other.faction != faction

# ===== прочее

func _ready():
	if Engine.editor_hint:
		set_physics_process(false)
	pass

func _physics_process(delta : float):
	process_movement(delta)

func can_see(other : LivingEntity) -> bool:
	var raycast := RayCast2D.new()
	$"/root/GlobalManager".gamemanager.add_child(raycast)
	raycast.cast_to = other.position - position
	raycast.position = position
	raycast.force_raycast_update()
	var return_data := raycast.get_collider() as LivingEntity == other
	raycast.queue_free()
	
	return return_data

func check_visual_contact(other : LivingEntity) -> bool:
	push_warning("check_visual_contact() is deprecated. use can_see() instead")
	
	return can_see(other)
