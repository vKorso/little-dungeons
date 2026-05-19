extends Node2D

func _ready() -> void:
	play_music()
	
func play_music():
	$Music.play()

func play_music_credits():
	stop_music_boss()
	$Credits.play()

func stop_music_credits():
	$Credits.stop()

func stop_music():
	$Music.stop()

func play_shoot_bow():
	$ShootBow.play()

func play_shoot_gun():
	$ShootGun.play()

func play_music_boss():
	stop_music()
	$MusicBossBattle.play()

func stop_music_boss():
	$MusicBossBattle.stop()
