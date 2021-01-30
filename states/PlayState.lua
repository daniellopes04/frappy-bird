--[[
    Part of "S50's Intro to Game Development"
    Lecture 1
    
    -- PlayState Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
    
    The PlayState is the bulk of the game. It includes all the logic for the bird
    and pipes, as well as collision between both.
]]

-- Inherits BaseState methods
PlayState = Class{__includes = BaseState}

-- Pipe sprite dimensions
PIPE_WIDTH = 52
PIPE_HEIGHT = 320

-- Pipe scroll speed
PIPE_SPEED = 60

-- Bird sprite dimensions
BIRD_WIDTH = 34
BIRD_HEIGHT = 24

function PlayState:init()
    -- Bird sprite
    self.bird = Bird()

    -- Pipes sprite list
    self.pipePairs = {}

    -- Elapsed time since last spawn and limit to next spawn
    self.spawnTimer = 0
    self.spawnLimit = math.random(1, 2) + math.random() + 0.5

    -- Last recorded y value
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    if scrolling == true then
        -- Spawn a pipe every spawnLimit seconds on the edge of screen
        self.spawnTimer = self.spawnTimer + dt

        if self.spawnTimer > self.spawnLimit then
            -- Modify y so the pipes aren't too far apart
            -- Pipe spawns no higher than 10 pixels below top edge of screen
            -- And no lower than the gap length
            local y = math.max(-PIPE_HEIGHT + 10,
                math.min(self.lastY + math.random(-40, 40), VIRTUAL_HEIGHT - GAP_HEIGHT - PIPE_HEIGHT - 26))
            self.lastY = y

            table.insert(self.pipePairs, PipePair(y))
            self.spawnTimer = 0
            self.spawnLimit = math.random(1, 2) + math.random() + 0.5
        end

        -- Moves pipes through the screen 
        for k, pair in pairs(self.pipePairs) do
            pair:update(dt)
        end

        -- Remove the flaggd pipes
        -- Since the removal of a table element shifts all the other elements
        -- This is done on a separate for so it doesn't interfere on other iterations
        for k, pair in pairs(self.pipePairs) do
            if pair.remove then
                table.remove(self.pipePairs, k)
            end
        end

        -- Moves the bird and flaps its wings
        self.bird:update(dt)

        -- Simple collision detection between bird and pipe pairs
        for k, pair in pairs(self.pipePairs) do
            for l, pipe in pairs(pair.pipes) do
                if self.bird:collides(pipe) then
                    gStateMachine:change("title")
                end
            end
        end

        -- Reset if we get to the ground or pass the top edge of screen
        if self.bird.y > VIRTUAL_HEIGHT - 15 or self.bird.y < 0 - 15 then
            gStateMachine:change("title")
        end
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    self.bird:render()
end

function PlayState:enter()
    -- If we're coming from death, restart scrolling
    scrolling = true

    -- Start bird movement
    birdMovement = true
end

function PlayState:exit()
    -- Stop scrolling for the death/score screen
    scrolling = false
    
    -- Stop bird movement
    birdMovement = false
end