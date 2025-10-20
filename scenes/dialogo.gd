extends Control

# Referências para os nós filhos que vamos usar
@onready var label_texto = $PainelFundo/TextoDialogo
@onready var timer_letras = $TimerLetras

var dialogo_completo: Array[String] = [] # Array com todas as "páginas" de diálogo
var pagina_atual: int = 0
var texto_sendo_exibido: String = ""
var exibicao_rapida: bool = false

# Velocidade do efeito de digitação (letras por segundo)
@export var velocidade_texto: float = 30.0

func _ready():
	# A caixa de diálogo começa escondida
	hide()
	timer_letras.timeout.connect(_on_timer_letras_timeout)

# Função pública para ser chamada de fora e iniciar o diálogo
func iniciar_dialogo(linhas: Array[String]):
	if linhas.is_empty():
		return

	self.dialogo_completo = linhas
	self.pagina_atual = 0
	self.exibicao_rapida = false
	show() # Mostra a caixa de diálogo
	_exibir_pagina_atual()

# Função para avançar o diálogo ou fechar a caixa
func _avancar_dialogo():
	# Se o texto ainda está sendo "digitado", mostra tudo de uma vez
	if not exibicao_rapida:
		exibicao_rapida = true
		label_texto.text = texto_sendo_exibido
		timer_letras.stop()
		return

	# Se já mostrou tudo, avança para a próxima página
	pagina_atual += 1
	if pagina_atual < dialogo_completo.size():
		_exibir_pagina_atual()
	else:
		# Acabou o diálogo
		dialogo_completo.clear()
		hide()

# Prepara e começa a exibir a página atual letra por letra
func _exibir_pagina_atual():
	texto_sendo_exibido = dialogo_completo[pagina_atual]
	label_texto.text = ""
	exibicao_rapida = false
	timer_letras.wait_time = 1.0 / velocidade_texto
	timer_letras.start()

# Chamado a cada "tick" do Timer para adicionar uma letra
func _on_timer_letras_timeout():
	if label_texto.text.length() < texto_sendo_exibido.length():
		label_texto.text += texto_sendo_exibido[label_texto.text.length()]
	else:
		timer_letras.stop()
		exibicao_rapida = true

# Captura a entrada do jogador para avançar
func _unhandled_input(event: InputEvent):
	# Verifica se a caixa está visível e se o jogador pressionou a tecla de "aceitar"
	if is_visible() and event.is_action_pressed("interact"):
		_avancar_dialogo()
		# Marca o evento como "tratado" para não ser processado por outros nós
		get_viewport().set_input_as_handled()
