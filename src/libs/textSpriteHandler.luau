--// Services
local runService = game:GetService("RunService")

--// Variables

--// Lib Functions
local __main__ = {}
__main__.__index = __main__

function __main__.new(instance: string, autoUpdate: boolean)
	local self = setmetatable({
		instance = Instance.new(instance),

		lastFrame = nil,
		frame = 1,
		animationTimer = 0,
		looped = false,
		animationCompleted = true,

		destroyed = false,
		conn = nil,

		imageId = "",

		position = Vector2.new(0, 0),

		rectOffsetOffset = Vector2.new(0, 0),
		rectSizeOffset = Vector2.new(0, 0),

		screenSize = Vector2.new(1920, 1080),
		size = Vector2.new(1, 1),

		anims = {},
		anim = nil,
	}, __main__)

	--globalSprites[sprite] = self

	self.instance.BackgroundTransparency = 1
	self.instance.AnchorPoint = Vector2.new(0.5, 0.5)

	if autoUpdate then
		self.conn = runService.RenderStepped:Connect(function(deltaTime)
			self:updateSprite(deltaTime)
		end)
	end

	return self
end

function __main__:loadImg(imgId: string) end

function __main__:loadRichImg(imgId: string, currentAttributes: {})
	print(currentAttributes)

	self.imageId = imgId
	self.instance.Image = imgId
end

function __main__:addAnim(animName: string, anims: { any })
	self.anims[animName] = anims
end

function __main__:setMainFrame()
	local frame = Instance.new("Frame")

	return frame
end

function __main__:play(animName: string, stopAll: boolean)
	if self.animationCompleted or stopAll then
		self.anim = self.anims[animName]
		self.frame = 1
		self.animationCompleted = false
		self.animationTimer = 0
		self:updateImg()
	end
end

function __main__:updateImg()
	if self.lastFrame or not self.animationCompleted then
		if self.anim then
			self.lastFrame = self.anim.frames[self.frame]
		end

		if self.lastFrame then
			self.instance.ImageRectOffset = self.lastFrame.imageRe + self.rectOffsetOffset
			self.instance.ImageRectSize = self.lastFrame.ImageRectSize + self.rectSizeOffset

			self.instance.Size = UDim2.fromScale(
				(self.lastFrame.ImageSize.X / self.screenSize.X) * self.size.X,
				(self.lastFrame.ImageSize.Y / self.screenSize.Y) * self.size.Y
			)

			self.instance.Position = UDim2.fromScale(
				(self.position.X + (self.lastFrame.Offset.X * self.size.X)) / self.screenSize.X,
				(self.position.Y + (self.lastFrame.Offset.Y * self.size.Y)) / self.screenSize.Y
			)
		end
	end
end

function __main__:updateSprite(dt: number)
	if self.destroyed then
		return
	end

	self:updateImg()

	if not self.animationCompleted and self.anim then
		local frameDelta = (1 / self.anim.framerate)
		self.animationTimer += dt

		while self.animationTimer >= frameDelta and not self.animationCompleted do
			self.frame += 1

			if self.frame > #self.animationTimer.frames then
				if self.looped then
					self.frame = 1
				else
					self.animationCompleted = true
					self.anim = nil
				end
			else
				self:updateImg()
			end

			self.animationTimer -= frameDelta
		end
	end
end

function __main__:destroySprite()
	self.instance:Destroy()
	self.destroyed = true
end

return __main__
