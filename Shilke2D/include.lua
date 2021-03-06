--[[---
Shilke2D/include is the entry point for each project based on Shilke2D.
There are some specific Shilke2D configuration options that must be set before to include
this file.
--]]

if __DEBUG_CALLBACKS__ == nil then
	--[[---
	Used to enable debug of default Shilke2D callbacks  (post draw and input callbacks)
	This feature relies on ZeroBraneStudio mobdebug feature so it can be enabled only
	when debugging from this IDE. By default is set to false
	--]]
	__DEBUG_CALLBACKS__ = false
end


if __USE_SIMULATION_COORDS__ == nil then
	--[[---
	--Shilke2D default coordinate system has (0,0) as topleft point and y grows from top to bottom. 
	It's possible to change coordinate system having (0,0) as bottomleft point and y growing from 
	bottom to top (so called coordinate system) setting this option to true
	By default is set to false
	--]]
	__USE_SIMULATION_COORDS__ = false
end

if __SHILKE2D_TWEEN__ == nil then
	--[[---
	Used to selective include tween library.
	By default tween library is loaded. 
	Define __SHILKE2D_TWEEN__ = false before include to disable it
	--]]
	__SHILKE2D_TWEEN__ = true
end


if __USE_MOAIJSONPARSER__ == nil then
	--[[---
	It's possible to use either native MOAIJsonParser or Shaun Brown lua 
	Json parser module
	
	By default MOAI native parser is used.
	Define __USE_MOAIJSONPARSER__ = false before include to disable MOAIJsonParser usage
	--]]
	__USE_MOAIJSONPARSER__ = true
end


if __JUGGLER_ON_SEPARATE_COROUTINE__ == nil then
	--[[---	
	By default the main juggler is updated in the mainLoop coroutine, before the update function call.
	Setting this to true forces the main juggler to be updated on a separate coroutine executed 
	before the mainLoop coroutine. 
	--]]
	__JUGGLER_ON_SEPARATE_COROUTINE__ = false
end


require("Shilke2D/Utils/ClassEx")
require("Shilke2D/Utils/Shape")
require("Shilke2D/Utils/Callbacks")
require("Shilke2D/Utils/IO")
require("Shilke2D/Utils/Log")
require("Shilke2D/Utils/Color")
require("Shilke2D/Utils/Graphics")
require("Shilke2D/Utils/Table")
require("Shilke2D/Utils/Sound")
require("Shilke2D/Utils/PerformanceTimer")
require("Shilke2D/Utils/ObjectPool")

require("Shilke2D/Utils/Polygon")
require("Shilke2D/Utils/PathFinding")
require("Shilke2D/Utils/Coroutines")

require("Shilke2D/Utils/Bitmap/BitmapRegion")
require("Shilke2D/Utils/Bitmap/BitmapData")

require("Shilke2D/Utils/Config/IniParser")
require("Shilke2D/Utils/Config/Json")
require("Shilke2D/Utils/Config/XmlNode")

require("Shilke2D/Utils/Math/Math")
require("Shilke2D/Utils/Math/Bezier")
require("Shilke2D/Utils/Math/BitOp")
require("Shilke2D/Utils/Math/Vec2")

require("Shilke2D/Utils/String/String")
require("Shilke2D/Utils/String/StringBuilder")
require("Shilke2D/Utils/String/StringReader")

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
require("Shilke2D/Display/BlendMode")
require("Shilke2D/Display/DisplayObj")
require("Shilke2D/Display/DisplayObjContainer")
require("Shilke2D/Display/Stage")
require("Shilke2D/Display/BaseQuad")
require("Shilke2D/Display/Quad")
require("Shilke2D/Display/Image")
require("Shilke2D/Display/MovieClip")
require("Shilke2D/Display/TextField")
require("Shilke2D/Display/Button")
require("Shilke2D/Display/DrawableObj")
--included here because it requires DisplayObjContainer
require("Shilke2D/Core/Stats")

--Shilke2D/Texture
require("Shilke2D/Texture/Texture")
require("Shilke2D/Texture/SubTexture")
require("Shilke2D/Texture/RenderTexture")
require("Shilke2D/Texture/ITextureAtlas")
require("Shilke2D/Texture/TextureAtlas")
require("Shilke2D/Texture/TextureAtlasComposer")
require("Shilke2D/Texture/TexturePacker")
require("Shilke2D/Texture/TextureManager")

--Shilke2D/Tween
if __SHILKE2D_TWEEN__ then
	require("Shilke2D/Tween/Tween")
	require("Shilke2D/Tween/TweenDelay")
	require("Shilke2D/Tween/Transition")
	require("Shilke2D/Tween/TweenEase")
	require("Shilke2D/Tween/TweenBezier")
	require("Shilke2D/Tween/TweenParallel")
	require("Shilke2D/Tween/TweenLoop")
	require("Shilke2D/Tween/TweenSequence")
	require("Shilke2D/Tween/DisplayObjTweener")
end