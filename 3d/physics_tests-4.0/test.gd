class_name Test
extends Node


signal wait_done()

var _timer
var _timer_started = false

var _wait_physics_ticks_counter = 0


func _physics_process(_delta):
	update_physics_ticks()


func update_physics_ticks():
	if (_wait_physics_ticks_counter > 0):
		_wait_physics_ticks_counter -= 1
		if (_wait_physics_ticks_counter == 0):
			emit_signal("wait_done")


func create_rigidbody_box(size):
	var template_shape = BoxShape3D.new()
	template_shape.size = size

	var template_collision = CollisionShape3D.new()
	template_collision.shape = template_shape

	var template_body = RigidBody3D.new()
	template_body.add_child(template_collision)

	return template_body


func start_timer(timeout):
	if _timer == null:
		_timer = Timer.new()
		_timer.one_shot = true
		add_child(_timer)
		_timer.connect("timeout", _on_timer_done)
	else:
		cancel_timer()

	_timer.start(timeout)
	_timer_started = true

	return _timer


func cancel_timer():
	if _timer_started:
		_timer.paused = true
		_timer.emit_signal("timeout")
		_timer.paused = false


func is_timer_canceled():
	return _timer.paused


func wait_for_physics_ticks(tick_count):
	_wait_physics_ticks_counter = tick_count
	return self


func _on_timer_done():
	_timer_started = false
