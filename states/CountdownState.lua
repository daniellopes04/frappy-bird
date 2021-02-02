--[[
    Part of "S50's Intro to Game Development"
    Lecture 1
    
    -- CountdownState Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
    
    The CountdownState prompts a countdown for the user before starting the game.
]]

-- Inherits BaseState methods
CountdownState = Class{__includes = BaseState}

-- Takes 1 second to countdown each time
COUNTDOWN_TIME = 0.75

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change("play")
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(tostring(self.count), -2, 118, VIRTUAL_WIDTH, "center")
end