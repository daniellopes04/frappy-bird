--[[
    Part of "S50's Intro to Game Development"
    Lecture 1
 
    -- PipePair Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
]]

PipePair = Class{}

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y
 
    -- Initializes pipe pair
    self.pipes = {
        ["upper"] = Pipe("top", self.y),
        ["lower"] = Pipe("lower", self.y + GAP_HEIGHT + PIPE_HEIGHT)
    }

    -- If the pair is past the left edge of the screen, it can be removed
    self.remove = false
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes["lower"].x = self.x
        self.pipes["upper"].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end