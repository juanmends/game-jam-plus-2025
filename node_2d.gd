extends Node2D

const STAR_COUNT := 150
const SHOOTING_STAR_INTERVAL := 2.5
const MAX_SHOOTING_STARS := 4

var stars := []
var shooting_stars := []
var time := 0.0
var fog_offset := 0.0
var moon_angle := 0.0

func _ready():
	randomize()
	_create_stars()

func _process(delta):
	time += delta
	fog_offset += delta * 0.15
	moon_angle += delta * 0.05

	# atualiza estrelas cadentes
	for s in shooting_stars:
		s.pos += s.vel * delta
		s.life -= delta
	shooting_stars = shooting_stars.filter(func(s): return s.life > 0)

	# cria novas estrelas cadentes
	if randf() < delta / SHOOTING_STAR_INTERVAL and shooting_stars.size() < MAX_SHOOTING_STARS:
		_spawn_shooting_star()

	queue_redraw()

func _draw():
	var size = get_viewport_rect().size

	# === Fundo gradiente cósmico ===
	var base_t = sin(time * 0.15) * 0.5 + 0.5
	var top_color = Color(0.05 + base_t * 0.05, 0.0, 0.1 + base_t * 0.1)
	var bottom_color = Color(0.0, 0.0, 0.03 + base_t * 0.05)
	for y in range(int(size.y)):
		var interp = float(y) / size.y
		var color = top_color.lerp(bottom_color, interp)
		draw_line(Vector2(0, y), Vector2(size.x, y), color, 1.0)

	# === Lua translúcida ===
	var moon_center = Vector2(size.x * 0.8, size.y * 0.25)
	moon_center.x += sin(moon_angle) * 40
	moon_center.y += cos(moon_angle) * 20
	draw_circle(moon_center, 40, Color(0.9, 0.9, 1.0, 0.08))
	draw_circle(moon_center, 30, Color(0.95, 0.95, 1.0, 0.15))
	draw_circle(moon_center, 20, Color(1.0, 1.0, 1.0, 0.25))

	# === Estrelas piscando coloridas ===
	for star in stars:
		var pulse = sin(time * star.speed + star.phase) * 0.5 + 0.5
		var color = star.color.lerp(Color(1, 1, 1), pulse)
		draw_circle(star.pos, 0.8 + pulse * 1.8, color)

	# === Neblina em camadas ===
	for i in range(5):
		var y = (sin(fog_offset + i) * 0.5 + 0.5) * size.y * 0.9
		var alpha = 0.03 + 0.02 * sin(time * 0.7 + i)
		draw_rect(Rect2(Vector2(0, y), Vector2(size.x, 60)), Color(0.2, 0.2, 0.4, alpha))

	# === Estrelas cadentes ===
	for s in shooting_stars:
		var start = s.pos
		var end = s.pos - s.vel.normalized() * 100
		draw_line(start, end, Color(1, 1, 1, 0.8), 2.0)
		draw_circle(start, 2.0, Color(1, 1, 1, 1))
		# traço residual (leve brilho da cauda)
		for i in range(1, 6):
			var fade = 1.0 - float(i) / 6.0
			var point = start - s.vel.normalized() * i * 15
			draw_circle(point, 1.0 + fade, Color(1, 1, 1, fade * 0.3))

class Star:
	var pos: Vector2
	var phase: float
	var speed: float
	var color: Color

class ShootingStar:
	var pos: Vector2
	var vel: Vector2
	var life: float

func _create_stars():
	var size = get_viewport_rect().size
	for i in range(STAR_COUNT):
		var s = Star.new()
		s.pos = Vector2(randf_range(0, size.x), randf_range(0, size.y))
		s.phase = randf() * TAU
		s.speed = randf_range(0.5, 3.0)
		# mistura entre azul, branco e dourado
		var hue = randf_range(0.55, 0.15) if randf() > 0.5 else randf_range(0.05, 0.15)
		s.color = Color.from_hsv(hue, randf_range(0.1, 0.4), 1.0)
		stars.append(s)

func _spawn_shooting_star():
	var size = get_viewport_rect().size
	var s = ShootingStar.new()
	s.pos = Vector2(randf_range(0, size.x), randf_range(0, size.y * 0.4))
	var direction = Vector2(1, 1).rotated(deg_to_rad(randf_range(-25, 25)))
	s.vel = direction.normalized() * randf_range(500, 800)
	s.life = randf_range(0.8, 1.6)
	shooting_stars.append(s)
