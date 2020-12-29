extends Test


var _do_raycasts = false


func _ready():
	await start_timer(0.5).timeout
	if is_timer_canceled():
		return

	_do_raycasts = true


func _physics_process(_delta):
	if !_do_raycasts:
		return

	_do_raycasts = false

	Log.print_log("* Start Raycasting...")

	clear_lines()

	for shape in $Shapes.get_children():
		var body = shape as PhysicsBody2D
		var space_state = body.get_world_2d().direct_space_state

		Log.print_log("* Testing: %s" % body.name)

		var center = body.global_transform.origin

		# Raycast entering from the top.
		var res = _add_raycast(space_state, center - Vector2(0, 100), center)
		Log.print_log("Raycast in: %s" % ("HIT" if res else "NO HIT"))

		# Raycast exiting from inside.
		center.x -= 20
		res = _add_raycast(space_state, center, center + Vector2(0, 200))
		Log.print_log("Raycast out: %s" % ("HIT" if res else "NO HIT"))

		# Raycast all inside.
		center.x += 40
		res = _add_raycast(space_state, center, center + Vector2(0, 40))
		Log.print_log("Raycast inside: %s" % ("HIT" if res else "NO HIT"))

		var body_name = String(body.name)
		if body_name.ends_with("ConcavePolygon"):
			# Raycast inside an internal face.
			center.x += 20
			res = _add_raycast(space_state, center, center + Vector2(0, 40))
			Log.print_log("Raycast inside face: %s" % ("HIT" if res else "NO HIT"))


func _add_raycast(space_state, pos_start, pos_end):
	var result = space_state.intersect_ray(pos_start, pos_end)
	var color
	if result:
		color = Color.gray
	else:
		color = Color.gray.darkened(0.6)

	# draw raycast line.
	add_line(pos_start, pos_end, color)

	# draw raycast arrow.
	add_line(pos_end, pos_end + Vector2(-5, -10), color)
	add_line(pos_end, pos_end + Vector2(5, -10), color)

	return result
