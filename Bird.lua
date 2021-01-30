--[[
    Part of "S50's Intro to Game Development"
    Lecture 1
 
    -- Bird Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
]]

Bird = Class{}

-- Gravity constant, used to simulate g
local GRAVITY = 20

-- Acceleration upwards that makes the bird jump onscreen
local ANTI_GRAVITY = -5

-- Used to update the bird's wings
local elapsedTime = 0

function Bird:init()
    math.randomseed(os.time())
    num = math.random(1, 3)

    -- Bird color is defined randomly
    if num == 1 then
        self.color = "yellow"
    elseif num == 2 then
        self.color = "blue"
    else
        self.color = "red"
    end

    -- Defines the wing movement of the bird
    -- 0 = midflap, 1 = upflap and 2 = downflap
    self.flap = 0

    -- Bird image is set to the respective sprite
    self.image = love.graphics.newImage("sprites/".. self.color .."bird-midflap.png")

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:update(dt)
    -- Updates the bird's wing movement every 0.2 seconds
    elapsedTime = elapsedTime + dt
    if elapsedTime > 0.2 then
        self.flap = (self.flap + 1) % 3
        elapsedTime = 0
    end

    -- Updates the bird sprite
    if self.flap == 0 then
        self.image = love.graphics.newImage("sprites/".. self.color .. "bird-midflap.png")
    elseif self.flap == 1 then
        self.image = love.graphics.newImage("sprites/".. self.color .. "bird-upflap.png")
    elseif self.flap == 2 then
        self.image = love.graphics.newImage("sprites/".. self.color .. "bird-downflap.png")
    end

    -- Updates bird position to make it fall on the screen
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy

    -- The bird jumps on screen when "space" gets pressed
    if love.keyboard.wasPressed("space") then
        self.dy = ANTI_GRAVITY
    end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end
