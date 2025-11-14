extends PanelContainer
@onready var puff_qtd = $PuffQtd

func setup(qtd):
	puff_qtd.text = qtd
