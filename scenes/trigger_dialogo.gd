extends Area2D

# Use @export para poder editar o diálogo diretamente no Inspetor da Godot!
@export var linhas_dialogo: Array[String] = [
	"Olá, aventureiro! Bem-vindo ao meu primeiro diálogo.",
    "Espero que esta caixa de diálogo tenha sido fácil de implementar."
]

# Uma flag para garantir que o diálogo só seja ativado uma vez
var ja_ativado: bool = false

# Esta função será conectada ao sinal "body_entered"
func _on_body_entered(body):
	# Verifica se o corpo que entrou é o jogador e se o diálogo ainda não foi ativado
	# (Assumindo que seu jogador está no grupo "player")
	if body.is_in_group("player") and not ja_ativado:
		ja_ativado = true
		# Encontra a caixa de diálogo na árvore de cenas e inicia o diálogo
		# ATENÇÃO: a caixa precisa estar na cena para isso funcionar!
		get_tree().get_root().find_child("CaixaDialogo", true, false).iniciar_dialogo(linhas_dialogo)
