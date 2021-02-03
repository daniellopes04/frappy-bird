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
    --  Bird sprite
    self.bird = Bird()

    -- Define the pipe color randomly
    local aux = love.math.random(2)

    if aux == 1 then
        PIPE_IMAGE = love.graphics.newImage("sprites/pipe-green.png")
    else
        PIPE_IMAGE = love.graphics.newImage("sprites/pipe-red.png")
    end

    -- Pipes sprite list
    self.pipePairs = {}

    -- Elapsed time since last spawn and limit to next spawn
    self.spawnTimer = 0
    self.spawnLimit = math.random(1, 2) + math.random() + 0.5

    -- Score during the play state
    self.score = 0

    -- Last recorded y value
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:enter(params)
    -- Receives bird passed by last state
    if params then
        self.bird = params.bird
    end
    -- Starts bird movement
    birdMovement = true
end

function PlayState:exit()    
    -- Stops bird movement
    birdMovement = false
end

function PlayState:update(dt)
    -- Spawn a pipe every spawnLimit seconds on the edge of screen
    self.spawnTimer = self.spawnTimer + dt

    if self.spawnTimer > self.spawnLimit then
        -- Modify y so the pipes aren't too far apart
        -- Pipe spawns no higher than 10 pixels below top edge of screen
        -- And no lower than the gap length
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-40, 40), VIRTUAL_HEIGHT - GAP_HEIGHT - PIPE_HEIGHT - 26))
        self.lastY = y

        -- Spawns a pipe pair
        table.insert(self.pipePairs, PipePair(y))

        -- Reset timer and define a new limit
        self.spawnTimer = 0
        self.spawnLimit = math.random(1, 2) + math.random() + 0.5
    end

    -- Moves pipes through the screen 
    for k, pair in pairs(self.pipePairs) do
        -- Scores a point if the pipes have gone past the bird all the way
        -- Only scores if pipe hasn't been scored yet
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds["point"]:play()
            end
        end

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
                sounds["hit"]:play()
                sounds["die"]:play()

                gStateMachine:change("score", {
                    score = self.score
                })
            end
        end
    end

    -- Reset if we get to the ground or pass the top edge of screen
    if self.bird.y > VIRTUAL_HEIGHT - 15 or self.bird.y < 0 - 15 then 
        sounds["swoosh"]:play()
        sounds["die"]:play()

        gStateMachine:change("score", {
            score = self.score
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    -- Prints the font two times, once in black, then again in white with a little offset
    -- This gives the effect of a black shadow to the text
    love.graphics.setFont(flappyFont)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(tostring(self.score), 0, 30, VIRTUAL_WIDTH, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(tostring(self.score), -2, 28, VIRTUAL_WIDTH, "center")

    self.bird:render()
end