extends Camera2D
## Drag the Player node here, or leave empty: uses parent → CollisionShape2D → this, so Player is two levels up.
@export var player: Player


# Match the scene toggle; keep camera state consistent on load.
func _ready() -> void:
	self.enabled = enabled
## Same value as `player.death` (read-only from the camera script).
# While the player is dead, park the camera off-screen instead of following the body.
func _process(_delta: float) -> void:
	var death = get_parent().get_parent().death
	if not is_instance_valid(player):
		return
	if death == true:
		_teleport_away_on_spike()


# On death, detach from the player node and snap the camera to a fixed off-screen position.
func _teleport_away_on_spike() -> void:
	# Detach from the player transform so we stay at world (1000, 1000) instead of following them.
	top_level = true
	position_smoothing_enabled = false
	position.x = -100
	position.y = -100


# Restore normal follow mode: re-parent to the player and reset local offset for the next life.
func reset_follow_player() -> void:
	top_level = false
	position_smoothing_enabled = true
	position = Vector2.ZERO


# Turn this camera on only for human player mode; AI modes use the AI camera instead.
func _on_main_menu_reset(type) -> void:
	if type == "player":
		self.enabled = true
		reset_follow_player()
	else:
		self.enabled = false
