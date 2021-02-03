--[[
    Part of "S50's Intro to Game Development"
    Lecture 1
    
    -- ScoreState Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
    
    The TitleScreenState is the starting screen of the game.
]]

-- Inherits BaseState methods
ScoreState = Class{__includes = BaseState}

-- Receives the high-score stored in the 'data.sav' file 
local highScore = 0

function ScoreState:init()
    -- Medal sprite
    self.image = love.graphics.newImage("sprites/bronze.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function ScoreState:enter(params)
    self.score = params.score

    if not love.filesystem.getInfo("data.sav") then
        love.filesystem.write("data.sav", self.score)
    else
        -- Saves new high-score to 'data.sav' file
        if self.score > highScore then
            highScore = self.score
            love.filesystem.write("data.sav", highScore)
        end
    end
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        gStateMachine:change("countdown")
    end
end

function ScoreState:render()
    -- Prints the font two times, once in black, then again in white with a little offset
    -- This gives the effect of a black shadow to the text
    love.graphics.setFont(flappyFont)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Game over", 0, 64, VIRTUAL_WIDTH, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Game over", -2, 62, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(mediumFont)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Score: ".. tostring(self.score), 0, 100, VIRTUAL_WIDTH, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Score: ".. tostring(self.score), -2, 98, VIRTUAL_WIDTH, "center")

    -- A medal is set to the player if a certain score is reached
    if self.score >= 10 then
        self.image = love.graphics.newImage("sprites/silver.png")
    elseif self.score >= 20 then
        self.image = love.graphics.newImage("sprites/gold.png")
    elseif self.score >= 30 then
        self.image = love.graphics.newImage("sprites/platinum.png")
    end

    -- Draws the medal
    love.graphics.draw(self.image, VIRTUAL_WIDTH / 2 - self.width / 2, 105 + self.height / 2)

    love.graphics.setFont(mediumFont)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("High Score: ".. tostring(highScore), 0, 160, VIRTUAL_WIDTH, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("High Score: ".. tostring(highScore), -2, 158, VIRTUAL_WIDTH, "center")

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Press enter to play again!", 0, 180, VIRTUAL_WIDTH, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press enter to play again!", -2, 178, VIRTUAL_WIDTH, "center")
end