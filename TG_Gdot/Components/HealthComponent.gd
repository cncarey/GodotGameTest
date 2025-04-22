extends Node

signal HealthChanged(newValue)
signal MaxHealthChanged(newValue)
signal Died()

@export var health: int = 5
@export var maxHealth: int = 10;
@export var currentHealth: int = 10;

func _Ready():
	currentHealth = maxHealth;
	MaxHealthChanged.emit(maxHealth)
	HealthChanged.emit(currentHealth)
		
func SetMaxHealth(max: int):
	maxHealth = max;
	MaxHealthChanged.emit(maxHealth)

func SetCurrentHealth(current: int):
	currentHealth = current
	HealthChanged.emit(currentHealth)


func Damage(damage: int):
	currentHealth = clamp(currentHealth - damage, 0, maxHealth);
	HealthChanged.emit(currentHealth)
	if (currentHealth == 0):
		Died.emit()
		

func Heal(amount: int):
	Damage(-amount)
