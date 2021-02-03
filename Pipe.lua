--[[
    Part of "S50's Intro to Game Development"
    Lecture 1
 
    -- Pipe Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
]]

Pipe = Class{}

function Pipe:init(orientation, y)
    self.image = PIPE_IMAGE
    self.x = VIRTUAL_WIDTH
    self.y = y

    -- self.width = PIPE_IMAGE:getWidth()
    self.width = PIPE_WIDTH
    -- self.height = PIPE_IMAGE:getHeight()
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)
end

function Pipe:render()
    -- Draws the pipe on screen
    -- Function draw(image, x, y, rotation, x scale, y scale)
    love.graphics.draw(self.image, self.x, 
        
        -- Shift pipe rendering down by its height if flipped vertically
        (self.orientation == "top" and self.y + self.height or self.y),
        
        -- Scaling by -1 on a given axis flips (mirrors) the image on that axis
        0, 1, self.orientation == "top" and -1 or 1)
end