@icon("res://addons/camera_2d_plus/images/node_icons/camera_2d_plus_icon.svg")
extends Camera2D
class_name Camera2DPlus

### Customizable Variables:
@export_group("Camera Follow")
@export_node_path("Node") var NODE_TO_FOLLOW_PATH: NodePath ## The node that the camera will follow. This only works properly if the Camera2D+ is not a child node of the node that is being followed.
@export var FOLLOW_OFFSET: Vector2 = Vector2.ZERO ## The offset position relative to the node that is being followed.

@export_group("Camera Shake")
@export_range(0.001, 1.0) var SHAKE_DECAY: float = 0.02 ## How long it takes the camera to completely stop shaking.
@export_range(0.0, 2.0) var SHAKE_ANGLE_MULTIPLIER: float = 1.0 ## How much the camera will rotate during shakes (won't work if IGNORE ROTATION is enabled).
@export_range(0.0, 2.0) var SHAKE_POSITION_MULTIPLIER: float = 1.0 ## How much the camera will shake.

@export_group("Camera Flash")
@export var ENABLE_CAMERA_FLASHING: bool = true ## Disable this if you don't want camera flashes to happen. Useful for photosensitive people.
@export_range(-99, 99) var FLASH_LAYER: int = 1 ## The layer of the CanvasLayer that the flash effects will be at.

@export_group("Camera Tilt")
@export_range(0.001, 1.0) var TILT_POSITION_DECAY: float = 0.05 ## How long it takes the camera to go back to its correct position.
@export_range(0.001, 1.0) var TILT_ANGLE_DECAY: float = 0.05 ## How long it takes the camera to go back to its correct angle.

@export_group("Cinematic Mode")
@export_range(0, 1280) var HORIZONTAL_CUT_SIZE: int = 100 ## The size of the horizontal cut when the cinematic mode is enabled.
@export_range(0, 1280) var VERTICAL_CUT_SIZE: int = 80 ## The size of the vertical cut when the cinematic mode is enabled.
@export_range(-99, 99) var CINEMATIC_LAYER: int = 2 ## The layer of the CanvasLayer that the cinematic effects will be at.

# Nodes:
@onready var node_to_follow: Node = get_node(NODE_TO_FOLLOW_PATH)

# Variables:
var flash_layer: CanvasLayer ## This variable is going to store the CanvasLayer that is going to store the flash related stuff.
var cinematic_layer: CanvasLayer ## This variable is going to store the CanvasLayer that is going to store the cinematic effect related stuff.

var flash_rect: ColorRect ## This variable is going to store the ColorRect responsable for the camera flashing.
var top_rect: ColorRect ## This variable is going to store the ColorRect responsable for the top cut during the cinematic effect.
var bottom_rect: ColorRect ## This variable is going to store the ColorRect responsable for the bottom cut during the cinematic effect.
var left_rect: ColorRect ## This variable is going to store the ColorRect responsable for the left cut during the cinematic effect.
var right_rect: ColorRect ## This variable is going to store the ColorRect responsable for the right cut during the cinematic effect.

var shake_strength: float = 0.0 ## This variable determines the current shake strength.
var horizontal_enabled: bool = false ## The value of this variable is determined by the state of the horizontal cinematic effect.
var vertical_enabled: bool = false ## The value of this variable is determined by the state of the vertical cinematic effect.

var position_tilt: Vector2 = Vector2.ZERO ## The camera's position tilt offset.
var angle_tilt: float = 0.0 ## The camera's angle tilt offset.


func _ready() -> void:
	## Adding all the necessary CanvasLayers so the Camera2D+ can work properly.
	flash_layer = CanvasLayer.new() # Creating a new CanvasLayer.
	flash_layer.name = "FlashLayer" # Updating the name of the new CanvasLayer.
	flash_layer.layer = FLASH_LAYER # Updating the layer of the new CanvasLayer.
	call_deferred("add_child", flash_layer) # Adding the new CanvasLayer to the scene.
	
	cinematic_layer = CanvasLayer.new() # Creating a new CanvasLayer.
	cinematic_layer.name = "CinematicLayer" # Updating the name of the new CanvasLayer.
	cinematic_layer.layer = CINEMATIC_LAYER # Updating the layer of the new CanvasLayer.
	call_deferred("add_child", cinematic_layer) # Adding the new CanvasLayer to the scene.
	
	## Adding all the necessary ColorRects so the Camera2D+ can work properly.
	flash_rect = ColorRect.new() # Creating a new ColorRect.
	flash_rect.name = "FlashRect" # Updating the name of the new ColorRect.
	flash_rect.size = get_viewport_rect().size # Updating the size of the new ColorRect to make it cover the entire screen.
	flash_rect.color = Color.TRANSPARENT # Updating the color of the new ColorRect.
	flash_layer.call_deferred("add_child", flash_rect) # Adding the new ColorRect to the scene.
	
	top_rect = ColorRect.new() # Creating a new ColorRect.
	top_rect.name = "TopRect" # Updating the name of the new ColorRect.
	top_rect.size = get_viewport_rect().size # Updating the size of the new ColorRect to make it cover the entire screen.
	top_rect.color = Color.BLACK # Updating the color of the new ColorRect.
	top_rect.global_position.y = -get_viewport_rect().size.y # Updating the position of the new ColorRect.
	cinematic_layer.call_deferred("add_child", top_rect) # Adding the new ColorRect to the scene.
	
	bottom_rect = ColorRect.new() # Creating a new ColorRect.
	bottom_rect.name = "BottomRect" # Updating the name of the new ColorRect.
	bottom_rect.size = get_viewport_rect().size # Updating the size of the new ColorRect to make it cover the entire screen.
	bottom_rect.color = Color.BLACK # Updating the color of the new ColorRect.
	bottom_rect.global_position.y = get_viewport_rect().size.y # Updating the position of the new ColorRect.
	cinematic_layer.call_deferred("add_child", bottom_rect) # Adding the new ColorRect to the scene.
	
	left_rect = ColorRect.new() # Creating a new ColorRect.
	left_rect.name = "LeftRect" # Updating the name of the new ColorRect.
	left_rect.size = get_viewport_rect().size # Updating the size of the new ColorRect to make it cover the entire screen.
	left_rect.color = Color.BLACK # Updating the color of the new ColorRect.
	left_rect.global_position.x = -get_viewport_rect().size.x # Updating the position of the new ColorRect.
	cinematic_layer.call_deferred("add_child", left_rect) # Adding the new ColorRect to the scene.
	
	right_rect = ColorRect.new() # Creating a new ColorRect.
	right_rect.name = "RightRect" # Updating the name of the new ColorRect.
	right_rect.size = get_viewport_rect().size # Updating the size of the new ColorRect to make it cover the entire screen.
	right_rect.color = Color.BLACK # Updating the color of the new ColorRect.
	right_rect.global_position.x = get_viewport_rect().size.x # Updating the position of the new ColorRect.
	cinematic_layer.call_deferred("add_child", right_rect) # Adding the new ColorRect to the scene.


func _process(_delta: float) -> void:
	## Applying the camera shake.
	rotation_degrees = randf_range(-shake_strength * SHAKE_ANGLE_MULTIPLIER, shake_strength * SHAKE_ANGLE_MULTIPLIER) + angle_tilt # Randomizing the camera angle.
	offset = Vector2(randf_range(-shake_strength * SHAKE_POSITION_MULTIPLIER, shake_strength * SHAKE_POSITION_MULTIPLIER), # Randomizing the camera offset.
					randf_range(-shake_strength * SHAKE_POSITION_MULTIPLIER, shake_strength * SHAKE_POSITION_MULTIPLIER)) + position_tilt
	
	if (shake_strength > 0): # Checking if the shake strength is greater than 0.
		shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY) # Slowly decreasing the shake strength if so.
		
	## Following the desired node.
	if (node_to_follow): # Checking if the node this camera should follow is valid.
		global_position = node_to_follow.global_position + FOLLOW_OFFSET # Updating the camera's position.
		
	## Resetting the camera tilt.
	position_tilt = lerp(position_tilt, Vector2.ZERO, TILT_POSITION_DECAY) # Resetting the position tilt.
	angle_tilt = lerpf(angle_tilt, 0.0, TILT_ANGLE_DECAY) # Resetting the angle tilt.


## This function instantly moves the camera, and slowly moves it back.
func tilt_position(tilt_x: float, tilt_y: float) -> void:
	# Sets the camera position's tilt x to "tilt_x" and y to "tilt_y".
	position_tilt = Vector2(tilt_x, tilt_y)


## This function instantly moves the camera, and slowly moves it back.
func tilt_angle(tilt: float) -> void:
	# Sets the camera angle's tilt to "tilt".
	angle_tilt = tilt


## This function updates the path of the node that is being followed.
func set_follow_node(new_node_path: NodePath) -> void:
	# Updating the node path variable.
	NODE_TO_FOLLOW_PATH = new_node_path
	
	# Updating the node variable.
	node_to_follow = get_node(NODE_TO_FOLLOW_PATH)


## This function makes the Camera2DPlus flash with a certain color and with a certain duration.
func flash(color: Color = Color.WHITE, duration: float = 0.5, hold: float = 0.0) -> void:
	## Checking if this function can run.
	if (not ENABLE_CAMERA_FLASHING): # Checking if the camera flashes are disabled.
		return # Stopping the function here if so.
		
	## Updating the FlashRect settings.
	flash_rect.color = color # Updating the FlashRect color.
	
	## Waiting before tweening the FlashRect back to transparent.
	await get_tree().create_timer(hold).timeout # Waiting before creating the tween.
		
	## Creating the tween that is going to make the camera flash.
	var tween: Tween = get_tree().create_tween() # Creating a new tween.
	tween.set_ease(Tween.EASE_OUT) # Updating the tween's easing style.
	tween.set_trans(Tween.TRANS_LINEAR) # Updating the tween's transition style.
	
	## Tweening the FlashRect back to transparent.
	tween.tween_property(flash_rect, "color", Color.TRANSPARENT, duration) # Tweening the FlashRect color.


## This function adds a certain value to the current shake strength.
func add_shake(strength: float) -> void:
	# Increasing the shake strength.
	shake_strength += strength # Adding `strength` to `shake_strength`.


## This function sets the current shake strength to a certain value.
func set_shake(strength: float) -> void:
	# Setting the shake strength.
	shake_strength = strength # Setting `shake_strength` to `strength`.


## This function toggles the cinematic mode.
func toggle_cinematic(horizontal: bool, vertical: bool = false) -> void:
	## Creating and setting up the Tween responsable for moving all the rects.
	var tween: Tween = get_tree().create_tween() # Creating a new Tween.
	tween.set_ease(Tween.EASE_IN_OUT) # Updating the Tween's easing type.
	tween.set_trans(Tween.TRANS_QUINT) # Updating the Tween's transition type.
	tween.set_parallel(true) # Making the Tween able to tween multiple properties at the same time.
	
	## Enabling / Disabling the horizontal cinematic mode.
	if (horizontal): # Checking if `horizontal` is true.
		## Tweening the position of the bottom and the top rect.
		tween.tween_property(bottom_rect, "global_position", Vector2(0, get_viewport_rect().size.y - HORIZONTAL_CUT_SIZE), 1.0) # Tweening the bottom rect.
		tween.tween_property(top_rect, "global_position", Vector2(0, -get_viewport_rect().size.y + HORIZONTAL_CUT_SIZE), 1.0) # Tweening the top rect.
	else:
		## Tweening the position of the bottom and the top rect.
		tween.tween_property(bottom_rect, "global_position", Vector2(0, get_viewport_rect().size.y + HORIZONTAL_CUT_SIZE), 1.0) # Tweening the bottom rect.
		tween.tween_property(top_rect, "global_position", Vector2(0, -get_viewport_rect().size.y - HORIZONTAL_CUT_SIZE), 1.0) # Tweening the top rect.
		
	## Enabling / Disabling the vertical cinematic mode.
	if (vertical): # Checking if `horizontal` is true.
		## Tweening the position of the bottom and the top rect.
		tween.tween_property(left_rect, "global_position", Vector2(-get_viewport_rect().size.x + VERTICAL_CUT_SIZE, 0), 1.0) # Tweening the left rect.
		tween.tween_property(right_rect, "global_position", Vector2(get_viewport_rect().size.x - VERTICAL_CUT_SIZE, 0), 1.0) # Tweening the right rect.
	else:
		## Tweening the position of the bottom and the top rect.
		tween.tween_property(left_rect, "global_position", Vector2(-get_viewport_rect().size.x - VERTICAL_CUT_SIZE, 0), 1.0) # Tweening the left rect.
		tween.tween_property(right_rect, "global_position", Vector2(get_viewport_rect().size.x + VERTICAL_CUT_SIZE, 0), 1.0) # Tweening the right rect.
		
	## Updating variables.
	horizontal_enabled = horizontal # Updating the horizontal variable.
	vertical_enabled = vertical # Updating the vertical variable.
