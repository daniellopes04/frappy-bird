--[[
    Part of "S50's Intro to Game Development"
    Lecture 1
 
    -- Bird Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
]]

Bird = Class{}

function Bird:init()
    math.randomseed(os.time())
    num = math.random(1, 3)
    if num == 1 then
        birdColor = "yellow"
    elseif num == 2 then
        birdColor = "blue"
    else
        birdColor = "red"
    end
        
    self.image = love.graphics.newImage("sprites/".. birdColor .."bird-midflap.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end