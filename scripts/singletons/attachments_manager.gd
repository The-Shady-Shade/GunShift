extends Node

var attachments_list: Dictionary = {
	"Power Shot": "+ A [shake]bunch more[/shake] damage
- Slightly lower fire rate
- Less ammo",
	
	"Burst": " + Fires 3 bullets in a row
+ Slightly more ammo
- Slightly lower damage",
	
	"Spray": " + [shake]Much higher[/shake] fire rate
+ A [shake]bunch more[/shake] ammo
- Much lower damage
- Longer reload",
	
	"Ricochet": "+ Bullets now [shake]bounce of the wall[/shake] 2 times
- Ouch, they can [shake]also hurt you[/shake]!",
	
	"Piercing Bullets": "+ Bullets now pass through enemies like butter
- Lower damage",
	
	"Auto Loader": "+ Killing an enemy [shake]instantly reloads[/shake] your gun
- Longer reload, so don't miss!",
	
	"Tank": "+ A [shake]bunch more[/shake] HP
- Longer dash cooldown",
	
	"Terrified Dash": "+ Firing your last bullet [shake]triggers a dash[/shake]
+ Slightly more HP
- Longer reload
- Longer dash cooldown",
	
	"Tactical Reload": "+ Dashing now [shake]instantly reloads[/shake] your gun
- A little longer dash cooldown",
	
	"Healing Leap": "+ Dashing now [shake]heals[/shake] you
+ Slightly more HP
- Longer dash cooldown",
}
var attachments: Array[String] = []

func attach(new_attachment: String) -> void:	
	var player: Player = global.player
	var weapon: Weapon = player.weapon
	
	if is_instance_valid(player):
		match new_attachment:
			"Power Shot":
				weapon.dmg += 60.0
				weapon.shoot_cd_max += 0.25
				weapon.ammo_max -= 2
			"Burst":
				weapon.burst_shots_max += 3
				weapon.ammo_max += 3
				weapon.dmg -= 5.0
			"Spray":
				weapon.spray = true
				weapon.shoot_cd_max -= 0.15
				weapon.ammo_max += 9
				weapon.dmg -= 20.0
				weapon.reload_time_max += 1.0
			"Ricochet":
				weapon.bounces_max += 2
			"Piercing Bullets":
				weapon.piercing_bullets = true
				weapon.dmg -= 10.0
			"Auto Loader":
				player.auto_loader = true
				weapon.reload_time_max += 0.5
			"Tank":
				player.hp_max += 100.0
				player.dash_cd_max += 1.0
			"Terrified Dash":
				player.terrified_dash = true
				player.hp_max += 25.0
				weapon.reload_time_max += 0.5
				player.dash_cd_max += 0.5
			"Tactical Reload":
				player.tactical_reload = true
				player.dash_cd_max += 0.5
			"Healing Leap":
				player.heal = true
				player.hp_max += 25.0
				player.dash_cd_max += 1.0
		
		attachments.append(new_attachment)
		
		player.hp = player.hp_max
		player.hp_bar.max_value = player.hp_max
		player.dash_bar.max_value = player.dash_cd_max
		
		weapon.ammo_max = clampi(weapon.ammo_max, 1, 15)
		weapon.ammo = weapon.ammo_max
		weapon.reload_bar.max_value = weapon.reload_time_max
		
		player.hp_bar.visible = true
		await get_tree().create_timer(0.5).timeout
	if is_instance_valid(player):
		player.hp_bar.visible = false
