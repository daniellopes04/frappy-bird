--[[
    Part of "S50's Intro to Game Development"
    Lecture 1
    
    -- TitleScreen Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
    
    The TitleScreenState is the starting screen of the game.
]]

-- Inherits BaseState methods
TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
    -- Bird sprite
    self.bird = Bird()
end

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        gStateMachine:change("play")
    end

    -- Moves the bird and flaps its wings
    self.bird:update(dt)
end

function TitleScreenState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf("Frappy Bird", 0, 60, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(mediumFont)
    love.graphics.printf("Press Enter", 0, 90, VIRTUAL_WIDTH, "center")

    self.bird:render()
end     