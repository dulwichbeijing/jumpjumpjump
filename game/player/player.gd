extends CharacterBody2D


const SPEED = 450.0
const JUMP_VELOCITY = -750.0

@onready var face: AnimatedSprite2D = $Body/Face
@onready var jump_sfx: AudioStreamPlayer2D = $JumpSfx

var difficulty:float = 1.0
var current_frame: int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		jump_sfx.play()
		velocity.y = JUMP_VELOCITY
		difficulty += 0.05
		current_frame = (current_frame + 1) % 8
		face.frame = current_frame
		
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED * difficulty
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if global_position.x < 0:
		global_position.x = get_viewport_rect().size.x
	
	if global_position.x > get_viewport_rect().size.x:
		global_position.x = 0

	move_and_slide()
