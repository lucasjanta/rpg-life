extends Control
@onready var total_timer_label = $"VBoxContainer/Weed&Timer/MarginContainer/FocusPanel/MarginContainer/VBoxContainer/stopwatch/TimerLabel"
@onready var quest_label = $"VBoxContainer/Weed&Timer/MarginContainer/FocusPanel/MarginContainer/VBoxContainer/VBoxContainer/QuestLabel"
@onready var session_timer_label = $"VBoxContainer/Weed&Timer/MarginContainer/FocusPanel/MarginContainer/VBoxContainer/HBoxContainer/PuffTimerLabel"
@onready var puff_progress_bar = $"VBoxContainer/Weed&Timer/MarginContainer/FocusPanel/MarginContainer/VBoxContainer/HBoxContainer/PuffProgressBar"
@onready var puffs_label = $"VBoxContainer/Weed&Timer/MarginContainer/FocusPanel/MarginContainer/VBoxContainer/HBoxContainer/AvailablePuffs"
@onready var play_button = $"VBoxContainer/Weed&Timer/MarginContainer/FocusPanel/MarginContainer/VBoxContainer/stopwatch/HBoxContainer/PlayButton"
@onready var pause_button = $"VBoxContainer/Weed&Timer/MarginContainer/FocusPanel/MarginContainer/VBoxContainer/stopwatch/HBoxContainer/PauseButton"
@onready var stop_button = $"VBoxContainer/Weed&Timer/MarginContainer/FocusPanel/MarginContainer/VBoxContainer/stopwatch/HBoxContainer/StopButton"


@onready var focus_panel = $"VBoxContainer/Weed&Timer/MarginContainer/FocusPanel"
@onready var weed_panel = $"VBoxContainer/Weed&Timer/MarginContainer/WeedPanel"

var total_time := 0.0
var session_time := 10.0 # 30 minutos
var current_session_time := 10.0

var is_running := false
var is_paused := false
var puffs := 0

func _process(delta: float) -> void:
	if not is_running or is_paused:
		return
	
	# Timer total (sobe)
	total_time += delta
	
	# Timer de sessão (desce)
	current_session_time -= delta
	
	# Atualiza UI
	update_total_timer_label()
	update_session_timer_label()
	update_progress_bar()
	
	# Se sessão chegou ao fim
	if current_session_time <= 0:
		puffs += 1
		puffs_label.text = str(puffs) + " PUFFS"
		current_session_time = session_time # reinicia sessão

func update_total_timer_label() -> void:
	var minutes = int(total_time / 60)
	var seconds = int(total_time) % 60
	total_timer_label.text = "%02d:%02d" % [minutes, seconds]

func update_session_timer_label() -> void:
	var minutes = int(current_session_time / 60)
	var seconds = int(current_session_time) % 60
	session_timer_label.text = "%02d:%02d" % [minutes, seconds]

func update_progress_bar() -> void:
	var progress = 1.0 - (current_session_time / session_time)
	puff_progress_bar.value = progress * 100.0

# --- Botões ---
func _on_play_button_pressed() -> void:
	is_running = true
	is_paused = false

func _on_pause_button_pressed() -> void:
	is_paused = not is_paused

func _on_stop_button_pressed() -> void:
	is_running = false
	is_paused = false
	total_time = 0.0
	current_session_time = session_time
	UserInfo.available_puffs += puffs
	puffs = 0
	puffs_label.text = "0 PUFFS"
	update_total_timer_label()
	update_session_timer_label()
	update_progress_bar()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_focus_button_pressed():
	focus_panel.visible = true
	weed_panel.visible = false


func _on_weed_button_pressed():
	focus_panel.visible = false
	weed_panel.visible = true
	weed_panel.update()
