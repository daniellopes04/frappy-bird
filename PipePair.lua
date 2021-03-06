--[[
    Part of "S50's Intro to Game Development"
    Lecture 1
 
    -- PipePair Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
]]

PipePair = Class{}

-- Gap height between pipes
GAP_HEIGHT = math.random(80, 120)

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH
    self.y = y
 
    -- Initializes pipe pair
    self.pipes = {
        ["upper"] = Pipe("top", self.y),
        ["lower"] = Pipe("lower", self.y + GAP_HEIGHT + PIPE_HEIGHT)
    }

    -- If the pair is past the left edge of the screen, it can be removed
    self.remove = false

    -- Whether or not this pair of pipes has been scored
    self.scored = false

    -- Generates a new random value for the next pair
    GAP_HEIGHT = math.random(80, 120)
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