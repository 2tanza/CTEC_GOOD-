extends CharacterBody2D


var acc = 90
var air_acc = 60
var friction = 110
var air_friction = 15
var in_air = 0
const speed = 1500


@export var move_speed : float = 40.0
@export var air_jumps_total : int = 1
var air_jumps_current : int = air_jumps_total
var wall_jumps_total: int = 1
var wall_jumps_current: int = wall_jumps_total


@export var jump_height : float = 275
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = .35

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-1.5 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

func _physics_process(delta):
	
	if velocity.y <= 1200:
		velocity.y += get_gravity() * delta
	if Input.is_action_pressed("ui_right"):
		pass
	else:
		pass
	if is_on_floor():
		in_air = 0
		air_jumps_current = air_jumps_total
	if not is_on_floor():
		in_air += .2
	if is_on_wall():
		fall_gravity = (((-1.5 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0)*.06
	else:
		fall_gravity = ((-1.5 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			jump()
		if in_air < 1.5 and not is_on_floor():
			jump()
		if is_on_wall_only() and wall_jumps_current > 0:
			wall_jump()
		if air_jumps_current > 0 and not is_on_floor():
			air_jump()

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and is_on_floor():
		velocity.x = move_toward(velocity.x, speed*direction, acc)
	elif direction and not is_on_floor():
		velocity.x = move_toward(velocity.x, speed*direction*.8, air_acc)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0 , friction)
	else:
		velocity.x = move_toward(velocity.x, 0, air_friction)

	move_and_slide()
func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump():
	wall_jumps_current = wall_jumps_total
	air_jumps_current = air_jumps_total
	velocity.y = jump_velocity
	
func air_jump():
	air_jumps_current -= 1
	wall_jumps_current = wall_jumps_total
	velocity.y = jump_velocity

func wall_jump():
	wall_jumps_current -= 1
	velocity.y = jump_velocity

func get_horizontal_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("ui_left"):
		horizontal -= 1.0
	if Input.is_action_pressed("ui_right"):
		horizontal += 1.0
	
	return horizontal
func attack_right():
	get_node("collision_HitBox_Right").disabled = false

func _on_area_2d_area_entered(area):
	pass # Replace with function body.
	# if area.is_in_group("hurtbox"):
	# 	takedamage
