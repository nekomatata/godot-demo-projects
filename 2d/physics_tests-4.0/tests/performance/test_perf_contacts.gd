extends Test


const OPTION_TYPE_ALL = "Shape type/All"
const OPTION_TYPE_RECTANGLE = "Shape type/Rectangle"
const OPTION_TYPE_SPHERE = "Shape type/Sphere"
const OPTION_TYPE_CAPSULE = "Shape type/Capsule"
const OPTION_TYPE_CONVEX_POLYGON = "Shape type/Convex Polygon"
const OPTION_TYPE_CONCAVE_POLYGON = "Shape type/Concave Polygon"
@export var spawns: Array = []

@export var spawn_count = 100
@export_range(1, 10) var spawn_multiplier = 5

var _object_templates = []


func _ready():
	await start_timer(0.5).timeout
	if is_timer_canceled():
		return

	while $DynamicShapes.get_child_count():
		var type_node = $DynamicShapes.get_child(0)
		type_node.position = Vector2.ZERO
		_object_templates.push_back(type_node)
		$DynamicShapes.remove_child(type_node)

	$Options.add_menu_item(OPTION_TYPE_ALL)
	$Options.add_menu_item(OPTION_TYPE_RECTANGLE)
	$Options.add_menu_item(OPTION_TYPE_SPHERE)
	$Options.add_menu_item(OPTION_TYPE_CAPSULE)
	$Options.add_menu_item(OPTION_TYPE_CONVEX_POLYGON)
	$Options.add_menu_item(OPTION_TYPE_CONCAVE_POLYGON)
	$Options.connect("option_selected", _on_option_selected)

	await _start_all_types()


func _exit_tree():
	for object_template in _object_templates:
		object_template.free()


func _on_option_selected(option):
	cancel_timer()

	_despawn_objects()

	match option:
		OPTION_TYPE_ALL:
			await _start_all_types()
		OPTION_TYPE_RECTANGLE:
			await _start_type(_find_type_index("Rectangle"))
		OPTION_TYPE_SPHERE:
			await _start_type(_find_type_index("Sphere"))
		OPTION_TYPE_CAPSULE:
			await _start_type(_find_type_index("Capsule"))
		OPTION_TYPE_CONVEX_POLYGON:
			await _start_type(_find_type_index("ConvexPolygon"))
		OPTION_TYPE_CONCAVE_POLYGON:
			await _start_type(_find_type_index("ConcavePolygon"))


func _find_type_index(type_name):
	for type_index in _object_templates.size():
		var type_node = _object_templates[type_index]
		if type_node.name.find(type_name) > -1:
			return type_index

	Log.print_error("Invalid shape type: " + type_name)
	return -1


func _start_type(type_index):
	if type_index < 0:
		return
	if type_index >= _object_templates.size():
		return

	await start_timer(1.0).timeout
	if is_timer_canceled():
		return

	_spawn_objects(type_index)

	await start_timer(1.0).timeout
	if is_timer_canceled():
		return

	_activate_objects()

	await start_timer(5.0).timeout
	if is_timer_canceled():
		return

	_despawn_objects()

	Log.print_log("* Done.")


func _start_all_types():
	for type_index in _object_templates.size():
		await start_timer(1.0).timeout
		if is_timer_canceled():
			return

		_spawn_objects(type_index)

		await start_timer(1.0).timeout
		if is_timer_canceled():
			return

		_activate_objects()

		await start_timer(5.0).timeout
		if is_timer_canceled():
			return

		_despawn_objects()

	Log.print_log("* Done.")


func _spawn_objects(type_index):
	var template_node = _object_templates[type_index]
	for spawn in spawns:
		var spawn_parent = get_node(spawn)

		Log.print_log("* Spawning: %s" % template_node.name)

		for _index in range(spawn_multiplier):
			for _node_index in spawn_count / spawn_multiplier:
				var node = template_node.duplicate() as Node2D
				spawn_parent.add_child(node)


func _activate_objects():
	var spawn_parent = $SpawnTarget1

	Log.print_log("* Activating")

	for node_index in spawn_parent.get_child_count():
		var node = spawn_parent.get_child(node_index) as RigidBody2D
		node.set_sleeping(false)


func _despawn_objects():
	for spawn in spawns:
		var spawn_parent = get_node(spawn)

		if spawn_parent.get_child_count() == 0:
			return

		Log.print_log("* Despawning")

		while spawn_parent.get_child_count():
			var node_index = spawn_parent.get_child_count() - 1
			var node = spawn_parent.get_child(node_index)
			spawn_parent.remove_child(node)
			node.queue_free()
