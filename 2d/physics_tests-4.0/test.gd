class_name Test
extends Node2D


var _timer
var _timer_started = false


class Line:
	var pos_start
	var pos_end
	var color
var _lines = []


func _draw():
	for line in _lines:
		draw_line(line.pos_start, line.pos_end, line.color, 1.5)


func add_line(pos_start, pos_end, color):
	var line = Line.new()
	line.pos_start = pos_start
	line.pos_end = pos_end
	line.color = color
	_lines.push_back(line)
	update()


func clear_lines():
	_lines.clear()
	update()


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


func _on_timer_done():
	_timer_started = false
