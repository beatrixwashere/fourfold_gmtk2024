# -- game_movement.gd ---
# handles player movement
# -----------------------
extends CharacterBody2D
# constants
const MOVE_MAX_SMALL: int = 300
const MOVE_ACC_SMALL: int = 30
const MOVE_ACC_AIR_SMALL: int = 20
const JUMP_INIT_SMALL: int = -400
const JUMP_GRAV_SMALL: int = 40
const JUMP_GRAV_LIGHT_SMALL: int = 20
const JUMP_COYOTE: int = 10
const DASH_POWER: int = 450
const DASH_ACC: int = 50
const DASH_DUR: int = 20
const DASH_CDN: int = 60
# variables
var inputs: Dictionary = {
	"up": false,
	"left": false,
	"down": false,
	"right": false,
	"jump": false,
	"dash": false,
	"enter": false }
var jump_state: int = 0
var jump_coyote: int = 0
var dash_state: int = 0
var dash_frame: int = 0
var dash_cdn: int = 0
var dash_pwr: int = DASH_POWER
var can_update: bool = true
# main loop
func _physics_process(_delta: float) -> void:
	if can_update:
		if dash_state == 0:
			player_move()
		if dash_state == 0 || is_on_floor():
			player_jump()
		player_dash()
		move_and_slide()
# basic movement
func player_move() -> void:
	if inputs["right"] && !inputs["left"]:
		velocity.x = move_toward(velocity.x, MOVE_MAX_SMALL, MOVE_ACC_SMALL)
	elif inputs["left"] && !inputs["right"]:
		velocity.x = move_toward(velocity.x, -MOVE_MAX_SMALL, MOVE_ACC_SMALL)
	else:
		velocity.x = move_toward(velocity.x, 0, MOVE_ACC_SMALL)
	#$sfx/walk.volume_db = 0 if (inputs["left"] || inputs["right"]) && is_on_floor() else -60
# jumping
func player_jump() -> void:
	# normal
	if jump_state == 0:
		if inputs["jump"]:
			velocity.y = JUMP_INIT_SMALL
			if dash_state > 0:
				dash_pwr += 150
			$sfx/jump.play()
			jump_state = 1
		if !is_on_floor():
			jump_coyote = JUMP_COYOTE
			jump_state = 2
	# rising
	elif jump_state == 1:
		if velocity.y == 0:
			jump_state = 2
		elif inputs["jump"]:
			velocity.y += JUMP_GRAV_LIGHT_SMALL
		else:
			velocity.y += JUMP_GRAV_SMALL
	elif jump_state == 2:
		if inputs["jump"] && jump_coyote > 0:
			velocity.y = JUMP_INIT_SMALL
			jump_coyote = 0
			$sfx/jump.play()
			jump_state = 1
		elif jump_coyote > 0:
			jump_coyote -= 1
		if is_on_floor():
			velocity.y = 0
			jump_coyote = 0
			jump_state = 0
		else:
			velocity.y += JUMP_GRAV_SMALL
# dashing
func player_dash() -> void:
	if dash_state == 0:
		if inputs["dash"] && dash_cdn == 0:
			velocity.x = int(inputs["right"]) - int(inputs["left"])
			velocity.y = int(inputs["down"]) - int(inputs["up"])
			velocity = velocity.normalized() * DASH_POWER
			if velocity == Vector2.ZERO:
				velocity = Vector2(DASH_POWER, 0)
			dash_frame = DASH_DUR
			dash_cdn = DASH_CDN
			dash_pwr = DASH_POWER
			$sfx/dash.play()
			dash_state = 1
	elif dash_state == 1:
		if dash_frame == 0:
			dash_state = 0
		else: 
			dash_frame -= 1
		velocity.x += DASH_ACC * (int(inputs["right"]) - int(inputs["left"]))
		velocity.y += DASH_ACC * (int(inputs["down"]) - int(inputs["up"]))
		velocity = velocity.normalized() * dash_pwr
	if dash_cdn > 0:
		dash_cdn -= 1
		$sprite/dash_cdn.value = dash_cdn
		$sprite/dash_cdn.visible = true
	else:
		$sprite/dash_cdn.visible = false
# handles input
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_W || event.keycode == KEY_UP: inputs["up"] = event.is_pressed()
		if event.keycode == KEY_A || event.keycode == KEY_LEFT: inputs["left"] = event.is_pressed()
		if event.keycode == KEY_S || event.keycode == KEY_DOWN: inputs["down"] = event.is_pressed()
		if event.keycode == KEY_D || event.keycode == KEY_RIGHT: inputs["right"] = event.is_pressed()
		if event.keycode == KEY_J || event.keycode == KEY_Z: inputs["jump"] = event.is_pressed()
		if event.keycode == KEY_K || event.keycode == KEY_X: inputs["dash"] = event.is_pressed()
		if event.keycode == KEY_SPACE: inputs["enter"] = event.is_pressed()
