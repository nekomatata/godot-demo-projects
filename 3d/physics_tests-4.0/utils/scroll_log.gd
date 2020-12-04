extends ScrollContainer


@export var auto_scroll = false


func _process(_delta):
	if auto_scroll:
		var scrollbar = get_v_scrollbar()
		scrollbar.value = scrollbar.max_value


func set_auto_scroll(value):
	auto_scroll = value
