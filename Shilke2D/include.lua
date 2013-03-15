__STARLING_TWEEN__ = true
__STARLING_TILEMAP__ = true
__STARLING_CONTROLLER__ = true

require("Shilke2D/Utils/ClassEx")
require("Shilke2D/Utils/Callbacks")
require("Shilke2D/Utils/IO")
require("Shilke2D/Utils/StringBuilder")
require("Shilke2D/Utils/Log")
require("Shilke2D/Utils/Math")
require("Shilke2D/Utils/Vector")
require("Shilke2D/Utils/Color")
require("Shilke2D/Utils/Shape")
require("Shilke2D/Utils/String")
require("Shilke2D/Utils/Table")
require("Shilke2D/Utils/XmlParser")
require("Shilke2D/Utils/XmlNode")
require("Shilke2D/Utils/IniParser")
require("Shilke2D/Utils/IniFile")
if __USE_SIMULATION_COORDS__ then
	require("Shilke2D/Utils/CollisionKitSim")
else	
	require("Shilke2D/Utils/CollisionKit")
end

require("Shilke2D/Utils/Polygon")
require("Shilke2D/Utils/PathFinding")
require("Shilke2D/Utils/Coroutines")

--Shilke2D/Core
require("Shilke2D/Core/Assets")
require("Shilke2D/Core/Event")
require("Shilke2D/Core/EventDispatcher")
require("Shilke2D/Core/IAnimatable")
require("Shilke2D/Core/Juggler")
require("Shilke2D/Core/TouchSensor")
require("Shilke2D/Core/Shilke2D")
require("Shilke2D/Core/Timer")
--should be included only on dektop devices, with modified sdk host (basic glut host do not handle special keys)
require("Shilke2D/Core/Keymap")

--Shilke2D/Display
require("Shilke2D/Display/DisplayObj")
require("Shilke2D/Display/DisplayObjContainer")
require("Shilke2D/Display/Stage")
require("Shilke2D/Display/FixedSizeObject")
require("Shilke2D/Display/Quad")
require("Shilke2D/Display/Image")
require("Shilke2D/Display/MovieClip")
require("Shilke2D/Display/TextField")
require("Shilke2D/Display/Button")
require("Shilke2D/Display/DrawableObject")

--Shilke2D/Texture
require("Shilke2D/Texture/Texture")
require("Shilke2D/Texture/SubTexture")
require("Shilke2D/Texture/TextureAtlas")
require("Shilke2D/Texture/BigTextureAtlas")
require("Shilke2D/Texture/TexturePacker")

--Shilke2D/Tween
require("Shilke2D/Tween/Tween")
require("Shilke2D/Tween/TweenDelay")
require("Shilke2D/Tween/Transition")
require("Shilke2D/Tween/TweenEase")
require("Shilke2D/Tween/Bezier")
require("Shilke2D/Tween/TweenBezier")
require("Shilke2D/Tween/TweenParallel")
require("Shilke2D/Tween/TweenLoop")
require("Shilke2D/Tween/TweenSequence")