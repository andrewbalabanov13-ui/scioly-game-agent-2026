extends Button


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	var world := get_node_or_null("../../..")
	if world == null:
		return

	var death_overlay := get_node_or_null("..") as Control
	if death_overlay:
		var lbl := death_overlay.get_node_or_null("GameOverLabel") as Label
		var btn := death_overlay.get_node_or_null("GameOverButton") as Button
		if lbl:
			lbl.visible = false
		if btn:
			btn.visible = false
		death_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var player := world.get_node_or_null("Player")
	if player != null and player.has_method("clear_game_over_state"):
		player.clear_game_over_state()

	var cam := world.get_node_or_null("Player/CollisionShape2D/Camera2D") as Camera2D
	if cam != null and cam.has_method("reset_follow_player"):
		cam.reset_follow_player()

	var main_menu := world.get_node_or_null("Ui - main menu/Overlay") as Control
	if main_menu != null and main_menu.has_method("open_main_menu"):
		main_menu.open_main_menu()
