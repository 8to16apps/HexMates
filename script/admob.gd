extends Node

var admob = null
var isReal = true
var isTop = true
var appId = "ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx"
var adBannerId = "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx" # [Replace with your Ad Unit ID and delete this message.]
var rewardLoaded = false;
var adRewardedId = "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx" # [There is no testing option for rewarded videos, so you can use this id for testing]

signal loadingVideoReward
signal enableVideoReward
signal rewardVideoReward

func _ready():
	if(Globals.has_singleton("AdMob")):
		admob = Globals.get_singleton("AdMob")
		admob.init(appId, isReal, get_instance_ID())
		loadBanner()
		loadRewardedVideo()
	
	get_tree().connect("screen_resized", self, "onResize")

# Loaders

func loadBanner():
	if admob != null:
		admob.loadBanner(adBannerId, isTop)

func loadRewardedVideo():
	if admob != null:
		emit_signal("loadingVideoReward")
		rewardLoaded = false;
		admob.loadRewardedVideo(adRewardedId)

func _on_admob_network_error():
	print("Network Error")

func _on_admob_ad_loaded():
	print("Ad loaded success")
	admob.showBanner()

func _on_rewarded_video_ad_loaded():
	print("Rewarded loaded success")
	emit_signal("enableVideoReward")

func _on_rewarded_video_ad_closed():
	print("Rewarded closed")
	loadRewardedVideo()

func _on_rewarded(currency, amount):
	print("Reward: " + currency + ", " + str(amount))
	rewardLoaded = true;
	emit_signal("rewardVideoReward")

func showVideoReward():
	if admob != null:
		admob.showRewardedVideo()
# Resize

func onResize():
	if admob != null:
		admob.resize()
