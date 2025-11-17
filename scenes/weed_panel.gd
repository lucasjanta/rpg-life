extends PanelContainer

@onready var puff_button = $MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/PuffButton
@onready var puffs_count = $MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/PuffsCount
@onready var high_progress_bar = $MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/HighProgressBar
@onready var day_sessions_container = $MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/DaySessionsContainer
@onready var state_container = $MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/StateContainer
@onready var state_label = $MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/StateContainer/StateLabel
@onready var weed_pet_texture = $MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/WeedPetTexture

const WEED_ICON = preload("uid://jtrsog0m6qfs")

# --- Configurações ---
const FILL_DURATION := 5.0 * 60.0 # 5 * 60.0 # 5 minutos
const DRAIN_DURATION := 120.0 * 60.0 # 2 * 60 * 60.0 # 2 horas

# --- Estado ---
var is_high := false
var progress := 0.0
var filling := false
var draining := false
var puffs_to_get_high : int = 0
# --- Variáveis de controle ---
var current_fill_time := 0.0
var current_drain_time := 0.0

func _ready():
	update_state_visual()
	update()
	
func update():
	puffs_count.text = str(UserInfo.available_puffs)
	if UserInfo.available_puffs == 0:
		puff_button.disabled = true
	else:
		puff_button.disabled = false
	

func _on_puff_button_pressed():
	UserInfo.available_puffs -= 1
	puffs_to_get_high += 1
	update()
	start_fill_phase()
	
# ============================================================
#                 LÓGICA DO HIGH BAR
# ============================================================

func _process(delta: float) -> void:
	if filling:
		current_fill_time += delta
		progress = clamp(current_fill_time / FILL_DURATION, 0.0, 1.0)
		high_progress_bar.value = progress * 100.0
		
		if progress >= 1.0:
			filling = false
			start_high_state()
	
	elif draining:
		current_drain_time += delta
		var drain_progress = 1.0 - (current_drain_time / DRAIN_DURATION)
		progress = clamp(drain_progress, 0.0, 1.0)
		high_progress_bar.value = progress * 100.0
		
		if progress <= 0.0:
			draining = false
			end_high_state()

# ============================================================
#                     ESTADOS
# ============================================================

func start_fill_phase():
	#if is_high or filling:
		#return
	filling = true
	draining = false
	current_fill_time = 0.0
	current_drain_time = 0.0

func start_high_state():
	is_high = true
	state_label.text = "HIGH"
	state_container.self_modulate = Color(1, 0.3, 0.3) # vermelho
	change_weed_pet()
	spawn_weed_icon()
	start_drain_phase()

func start_drain_phase():
	filling = false
	draining = true
	current_drain_time = 0.0

func end_high_state():
	is_high = false
	change_weed_pet()
	state_label.text = "SOBER"
	state_container.self_modulate = Color(0.3, 1, 0.3) # verde

func update_state_visual():
	if is_high:
		state_label.text = "HIGH"
		state_container.self_modulate = Color(1, 0.3, 0.3)
	else:
		state_label.text = "SOBER"
		state_container.self_modulate = Color(0.3, 1, 0.3)

# ============================================================
#               ADICIONAR ÍCONE DE PUFF
# ============================================================

func spawn_weed_icon():
	var icon = WEED_ICON.instantiate()
	day_sessions_container.add_child(icon)
	icon.puff_qtd.text = str(puffs_to_get_high)
	puffs_to_get_high = 0

func change_weed_pet():
	if is_high:
		weed_pet_texture.texture = load("res://assets/ui/weed_pet/stoned.png")
	else:
		weed_pet_texture.texture = load("res://assets/ui/weed_pet/sober.png")
		
