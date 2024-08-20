# -- game_movement.gd ---
# handles player movement
# -----------------------
extends CharacterBody2D
# constants
var MOVE_MAX: int = 300 + sequence.upgrades[0] * 50
const MOVE_ACC: int = 30
const MOVE_ACC_AIR: int = 20
var JUMP_INIT: int = -400 + sequence.upgrades[1] * -50
const JUMP_GRAV: int = 40
const JUMP_GRAV_LIGHT: int = 20
const JUMP_COYOTE: int = 10
var DASH_POWER: int = 450 + sequence.upgrades[2] * 50
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
		# animation
		if dash_state > 0:
			$sprite.animation = "dash"
		elif jump_state > 0:
			$sprite.animation = "jump"
		elif (inputs["left"] || inputs["right"]) && is_on_floor():
			$sprite.animation = "move"
		else:
			$sprite.animation = "idle"
# basic movement
func player_move() -> void:
	if inputs["right"] && !inputs["left"]:
		velocity.x = move_toward(velocity.x, MOVE_MAX, MOVE_ACC)
		$sprite.flip_h = false
	elif inputs["left"] && !inputs["right"]:
		velocity.x = move_toward(velocity.x, -MOVE_MAX, MOVE_ACC)
		$sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, MOVE_ACC)
	#$sfx/walk.volume_db = 0 if (inputs["left"] || inputs["right"]) && is_on_floor() else -60
# jumping
func player_jump() -> void:
	# normal
	if jump_state == 0:
		if inputs["jump"]:
			velocity.y = JUMP_INIT
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
			velocity.y += JUMP_GRAV_LIGHT
		else:
			velocity.y += JUMP_GRAV
	elif jump_state == 2:
		if inputs["jump"] && jump_coyote > 0:
			velocity.y = JUMP_INIT
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
			velocity.y += JUMP_GRAV
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
		$sprite.flip_h = velocity.x < 0
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
