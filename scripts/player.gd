class_name player
extends CharacterBody2D

signal level_completed

var tile_size:= 16
var tracker_src: int
var tracker_atlas: Vector2i

@export var boxLayer: TileMapLayer
@onready var sprite :=  $Sprite2D

var tracker_position_array:= []

func is_movable(cell:Vector2i)->bool:
	var data = boxLayer.get_cell_tile_data(cell)
	return data != null and data.get_custom_data("moveable") == true

func is_solid(cell:Vector2i)->bool:
	var data = boxLayer.get_cell_tile_data(cell)
	return data != null and data.get_custom_data("solid") == true

func is_tracker(cell:Vector2i)->bool:
	var data = boxLayer.get_cell_tile_data(cell)
	return data != null and data.get_custom_data("tracker") == true

func restore_trackers():
	for cell in tracker_position_array:
		if boxLayer.get_cell_source_id(cell) == -1:
			boxLayer.set_cell(cell,tracker_src,tracker_atlas)

func get_player_cell()->Vector2i:
	return boxLayer.local_to_map(boxLayer.to_local(sprite.global_position))

func tracker_left():
	var count: = 0
	for cell in boxLayer.get_used_cells():
		if is_tracker(cell):
			count+=1
	return count

func get_tracker_position() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for cell in boxLayer.get_used_cells():
		if is_tracker(cell):
			result.append(cell)
	return result

func _ready() -> void:
	tracker_position_array = get_tracker_position()
	if tracker_position_array.size() > 0:
		var first :Vector2i= tracker_position_array[0]
		tracker_src = boxLayer.get_cell_source_id(first)
		tracker_atlas = boxLayer.get_cell_atlas_coords(first)

func _physics_process(delta: float) -> void:
	
	var direction:=Vector2i.ZERO
	
	if Input.is_action_just_pressed("left"):
		direction = Vector2i.LEFT
	if Input.is_action_just_pressed("right"):
		direction = Vector2i.RIGHT
	if Input.is_action_just_pressed("up"):
		direction = Vector2i.UP
	if Input.is_action_just_pressed("down"):
		direction = Vector2i.DOWN
	if Input.is_action_pressed("back"):
		get_tree().change_scene_to_packed(load("res://scenes/level_selector.tscn"))
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	
	if direction != Vector2i.ZERO:
		move_one_tile(direction)
		

func move_one_tile(direction:Vector2i):
	var motion:= Vector2(direction) * tile_size
	var current_cell := get_player_cell()
	var target_cell := current_cell + direction

	if is_movable(target_cell):
		var beyond: = target_cell + direction
		if is_solid(beyond):
			return
		
		var landed_on_tracker := is_tracker(beyond)
		
		var src: = boxLayer.get_cell_source_id(target_cell)
		var atlas = boxLayer.get_cell_atlas_coords(target_cell)
		boxLayer.erase_cell(target_cell)
		boxLayer.set_cell(beyond,src,atlas)
		
		restore_trackers()
		
		if is_solid(target_cell):
			return
		
		if landed_on_tracker:
			if tracker_left() == 0:
				level_completed.emit()
				set_physics_process(false)
				
		global_position +=motion
		return
		
	if not test_move(transform,motion):
		position += motion


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var cell := boxLayer.local_to_map(boxLayer.get_local_mouse_position())
		print("clicked cell ", cell)
