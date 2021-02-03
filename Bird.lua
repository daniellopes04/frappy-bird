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

-- Used to update the bird's sprite to move its wings
local birdTimer = 0

function Bird:init()
    -- Bird color is defined randomly
    local num = love.math.random(3)

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

    self.width = BIRD_WIDTH
    self.height = BIRD_HEIGHT
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:collides(pipe)
    -- The 2's and 4's are left/top and right/bottom offsets, respectively
    -- Both offsets are used to shrink the bounding box, so the gameplay isn't too hard
    if (self.x + 2) + (self.width - 8) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 8) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end
    
    return false
end

function Bird:update(dt)
    -- Updates the bird's wing movement every 0.2 seconds
    birdTimer = birdTimer + dt
    
    if birdTimer > 0.2 then
        self.flap = (self.flap + 1) % 3
        birdTimer = 0
    end

    -- Updates the bird sprite
    if self.flap == 0 then
        self.image = love.graphics.newImage("sprites/".. self.color .. "bird-midflap.png")
    elseif self.flap == 1 then
        self.image = love.graphics.newImage("sprites/".. self.color .. "bird-upflap.png")
    elseif self.flap == 2 then
        self.image = love.graphics.newImage("sprites/".. self.color .. "bird-downflap.png")
    end

    if birdMovement == true then
        -- Updates bird position to make it fall on the screen
        self.dy = self.dy + GRAVITY * dt
        self.y = self.y + self.dy

        -- The bird jumps on screen when "space" gets pressed
        if love.keyboard.wasPressed("space") or love.mouse.wasPressed(1) then
            self.dy = ANTI_GRAVITY
            sounds["wing"]:play()
        end
    end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end
