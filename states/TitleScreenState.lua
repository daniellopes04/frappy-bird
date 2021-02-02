--[[
    Part of "S50's Intro to Game Development"
    Lecture 1
    
    -- TitleScreenState Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
    
    The TitleScreenState is the starting screen of the game.
]]

-- Inherits BaseState methods
TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
    self.bird = Bird()
end

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        gStateMachine:change("countdown", {
            bird = self.bird
        })
    end

    self.bird:update(dt)
end

function TitleScreenState:render()
    -- Prints the font two times, once in black, then again in white with a little offset
    -- This gives the effect of a black shadow to the text
    love.graphics.setFont(flappyFont)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Frappy Bird", 0, 60, VIRTUAL_WIDTH, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Frappy Bird", -2, 58, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(mediumFont)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Press Enter", 0, 100, VIRTUAL_WIDTH, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press Enter", -2, 98, VIRTUAL_WIDTH, "center")

    self.bird:render()
end     