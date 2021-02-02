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

function ScoreState:init()
    -- Medal sprite
    self.image = love.graphics.newImage("sprites/bronze.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function ScoreState:enter(params)
    self.score = params.score
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

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Press enter to play again!", 0, 160, VIRTUAL_WIDTH, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press enter to play again!", -2, 158, VIRTUAL_WIDTH, "center")
end     