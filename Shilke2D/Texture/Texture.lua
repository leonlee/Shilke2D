--[[---
A texture stores the information that represents an image. It cannot 
be added to the display list directly; instead it has to be mapped 
into a display object, that is the class "Image".

A Texture is a GPU bitmap object that can be diplayed o screen but cannot be modified at runtime.
It's created loading into GPU memory a CPU Bitmap.
--]]

Texture = class()

---Max widht of Texture object
Texture.MAX_WIDTH = 4096
---Max height of Texture object
Texture.MAX_HEIGHT = 4096

--[[---
Creates an empty, transparent texture of specific width and height
@tparam int width texture width
@tparam int height texture height
@treturn Texture empty texture
--]]
function Texture.empty(width, height)
	assert(width<=Texture.MAX_WIDTH and height <= Texture.MAX_HEIGHT)
	local img = MOAIImage.new()
	img:init(width,height)
    return Texture(img)
end

--[[---
Creates a texture of specific width and height and color
@tparam int width texture width
@tparam int height texture height
@tparam int r red value [0,255] or a Color
@tparam int g green value [0,255] or nil
@tparam int b blue value [0,255] or nil
@tparam int a alpha value [0,255] or nil
@treturn Texture a texture filled with the given color
--]]
function Texture.fromColor(width, height, r, g, b, a)
	assert(width<=Texture.MAX_WIDTH and height <= Texture.MAX_HEIGHT)
	local img = MOAIImage.new()
	img:init(width,height)
	local r,g,b,a = Color._paramConversion(r,g,b,a,1)
	img:fillRect (0,0,width,height,r,g,b,a)
    return Texture(img)
end


--[[---
Load an external file and create a texture. 
ColorTransform options can be provided, where PREMULTIPLY_ALPHA is the default value. 
If a texture is created with straight alpha, once the texture is assigned to a displayObj 
(image or subclasses) the premultiplyAlpha value of the object should be changed accordingly.

@tparam string fileName the name of the image file to load
@tparam[opt=ColorTransform.PREMULTIPLY_ALPHA] ColorTransform transformOptions
@treturn[1] Texture
@return[2] nil
@treturn[2] string error message
--]]
function Texture.fromFile(fileName, transformOptions)
	local srcData, err = BitmapData.fromFile(fileName, transformOptions)
	if not srcData then
		return nil, err
	end
	return Texture(srcData)
end


--[[---
Constructor.
Create a Texture starting from a MOAI object. 
@param srcData can be a MOAIImage (or a derived MOAIImageTexture), or a MOAIFrameBuffer
@tparam[opt=nil] Rect frame
--]]
function Texture:init(srcData, frame)
	--invalidate is a specific "MOAIImageTexture" (userdata) method
    if srcData.invalidate then
		self.srcData = srcData
		self.textureData = srcData
	--bleedRect is a specific "MOAIImage" (userdata) method
    elseif srcData.bleedRect then
		self.srcData = srcData
		self.textureData = MOAITexture.new()
		self.textureData:load(self.srcData)
	--getRenderTable is a specific "MOAIFrameBufferTexture" (userdata) method
    elseif srcData.getRenderTable then
		self.srcData = srcData
		self.textureData = srcData
	else
		error("Texture accept MOAIImage, MOAIImageTexture or MOAIFrameBufferTexture")
    end
	
	self.rotated = false
	self.trimmed = frame ~= nil
	self.region = Rect(0,0,self.textureData:getSize())
	self.frame = frame or self.region
end


---When called textureData (MOAITexture) is released
function Texture:dispose()
	if self.textureData then
		self.textureData:release()
	end
	self.textureData = nil
	self.region = nil
	self.frame = nil
	self.srcData = nil
	self._quad = nil
end

function Texture:getSrcData()
	return self.srcData
end

function Texture:releaseSrcData()
	self.srcData = nil
end


--[[---
Returns the width of the texture in pixels
@treturn int width
--]]
function Texture:getWidth()
	return self.frame.w
end

--[[---
Returns the height of the texture in pixels
@treturn int height
--]]
function Texture:getHeight()
	return self.frame.h
end

--[[---
Returns the size of the texture in pixels
@treturn int width
@treturn int height
--]]
function Texture:getSize()
	return self.frame.w, self.frame.h
end

--[[---
Returns the region as pixel rect over srcdata. It doesn't take care of the rotated flag
@tparam[opt=nil] Rect resultRect if provided is filled and returned
@treturn Rect
--]]
function Texture:getRegion(resultRect)
	local res = resultRect or Rect()
	res:copy(self.region)
	return res
end

function Texture:getFrame(resultRect)
	local res = resultRect or Rect()
	res:copy(self.frame)
	return res
end

--[[---
Returns the region as uv rect over srcdata. It doesn't take care of the rotated flag
@tparam[opt=nil] Rect resultRect if provided is filled and returned
@treturn Rect (values are [0..1])
--]]
function Texture:getRegionUV(resultRect)
	local res = self:getRegion(resultRect)
	local w,h = self.textureData:getSize()
	res.x, res.w = res.x / w, res.w / w
	res.y, res.h = res.y / h, res.h / h
	return res
end

--definition of local helper function names
local _region2rect, _region2quad = nil, nil

if __USE_SIMULATION_COORDS__ then
	--[[---
	if the texture is not rotated a region is mapped as a rect, with
	y coords varying based on Shilke2D coordinate space
	@tparam Rect r the region to transform
	@treturn int x
	@treturn int y
	@treturn int w
	@treturn int h
	--]]
	_region2rect = function(r)
		return r.x, r.y + r.h, r.x + r.w, r.y
	end

	--[[
	if the texture is rotated a region is mapped as a quad, with
	y coords varying based on Shilke2D coordinate space
	@tparam Rect r the region to transform
	@treturn int x1
	@treturn int y1
	@treturn int x2
	@treturn int y2
	@treturn int x3
	@treturn int y3
	@treturn int x4
	@treturn int y4
	--]]
	_region2quad = function(r)
		return	r.x + r.w, r.y,
				r.x + r.w, r.y + r.h,
				r.x, r.y + r.h,
				r.x, r.y
	end
	
	function Texture:_getQuadRect(quad)
		local rw, rh
		if self.rotated then
			rw,rh = self.region.h, self.region.w
		else
			rw,rh = self.region.w, self.region.h
		end
		return 	self.frame.x, 
				self.frame.h - (self.frame.y + rh), 
				self.frame.x + rw,
				self.frame.h - self.frame.y 
	end
	
else -- not __USE_SIMULATION_COORDS__
	
	_region2rect = function(r)
		return r.x, r.y, r.x + r.w, r.y + r.h
	end

	_region2quad = function(r)
		return	r.x, r.y,
				r.x, r.y + r.h,
				r.x + r.w, r.y + r.h,
				r.x + r.w, r.y
	end

	function Texture:_getQuadRect(quad)
		local rw, rh
		if self.rotated then
			rw,rh = self.region.h, self.region.w
		else
			rw,rh = self.region.w, self.region.h
		end
		return 	self.frame.x, 
				self.frame.y, 
				self.frame.x + rw, 
				self.frame.y + rh
	end
	
end

local __helperRect = Rect()

--[[---
Inner method. Called internally to correctly map texture uv
@param quad the external MOAIGfxQuad2D or MOAIGfxQuadDeck2D structure to be filled
@int[opt=nil] index if quad is a MOAIGfxQuadDeck2D a index of the quad/texture inside 
the quadDeck must be provided
--]]
function Texture:_fillQuadUV(quad, index)
	local r = self:getRegionUV(__helperRect)
	local params, func = nil, nil
	if self.rotated then
		params = {_region2quad(r)}
		func = quad.setUVQuad
	else
		params = {_region2rect(r)}
		func = quad.setUVRect
	end
	if index ~= nil then
		table.insert(params, 1, index)
	end
	func(quad, unpack(params))
end


--[[---
Inner method. 
Creates and caches a MOAIGfxQuad2D used and shared by Images to show the texture.
If a texture is not binded to an Image the MOAIGfxQuad2D is never created
@return MOAIGfxQuad2D
--]]
function Texture:_generateQuad()
	local quad = MOAIGfxQuad2D.new()
	quad:setTexture(self.textureData)
	quad:setRect(self:_getQuadRect())
	self:_fillQuadUV(quad)
	return quad
end

--[[---
Inner method. 
Creates and caches a MOAIGfxQuad2D used and shared by Images to show the texture.
If a texture is not binded to an Image the MOAIGfxQuad2D is never created
@return MOAIGfxQuad2D
--]]
function Texture:_getQuad()
	if not self._quad then
		self._quad = self:_generateQuad()
	end
	return self._quad
end
