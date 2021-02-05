--[[
    Part of "S50's Intro to Game Development"
    Lecture 1
    
    -- Implementation of mobile game "Flappy Bird" --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
]]

-- Push library
-- https://github.com/Ulydev/push
push = require "push"

-- Class library
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require "class"

-- Loads the created classes
require "Bird"
require "Pipe"
require "PipePair"
require "StateMachine"
require "states/BaseState"
require "states/PlayState"
require "states/TitleScreenState"
require "states/ScoreState"
require "states/CountdownState"

-- Physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtual screen dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Gets the current hour, to update the sprites
CURRENT_HOUR = tonumber(os.date("%H"))

-- Loads background sprite and sets its scroll value
local background = love.graphics.newImage("sprites/background-day.png")
local backgroundScroll = 0

-- Loads foreground sprite and sets its scroll value
local ground = love.graphics.newImage("sprites/ground-day.png")
local groundScroll = 0

-- Speed at which the sprites will move to the left on screen
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- Defines a looping point based on repetition of the texture chosen
local BACKGROUND_LOOPING_POINT = 514

-- Defines if the game is paused
local pause = false

-- Runs when the game starts, only once
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Frappy Bird")

    -- Seed the random number generator function
    love.math.setRandomSeed(os.time())

    -- Loads the fonts used in the game
    smallFont = love.graphics.newFont("fonts/font.ttf", 8)
    mediumFont = love.graphics.newFont("fonts/flappy.ttf", 14)
    flappyFont = love.graphics.newFont("fonts/flappy.ttf", 28)
    hugeFont = love.graphics.newFont("fonts/flappy.ttf", 56)
    love.graphics.setFont(flappyFont)

    -- Table of sounds of the game
    sounds = {
        ["hit"] = love.audio.newSource("sounds/hit.wav", "static"),
        ["die"] = love.audio.newSource("sounds/die.wav", "static"),
        ["swoosh"] = love.audio.newSource("sounds/swoosh.wav", "static"),
        ["wing"] = love.audio.newSource("sounds/wing.wav", "static"),
        ["point"] = love.audio.newSource("sounds/point.wav", "static")
    }

    -- Changes the background and ground sprites based on hour of day
    if CURRENT_HOUR >= 18 or (CURRENT_HOUR >= 0 and CURRENT_HOUR <= 6) then
        background = love.graphics.newImage("sprites/background-night.png")
        ground = love.graphics.newImage("sprites/ground-night.png")
    elseif CURRENT_HOUR == 17 or CURRENT_HOUR == 18 then
        background = love.graphics.newImage("sprites/background-sunset.png")
    end

    -- Setting up the screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- Initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ["title"] = function() 
            return TitleScreenState() 
        end,
        ["play"] = function() 
            return PlayState() 
        end,
        ["score"] = function() 
            return ScoreState() 
        end,
        ["countdown"] = function()
            return CountdownState()
        end
    }
    gStateMachine:change("title")

    -- Keeps track of the keys pressed by the user
    love.keyboard.keysPressed = {}

    -- Keeps track of the mouse clicks of the user
    love.mouse.buttonsPressed = {}
end

-- Called by love2d whenever we resize the screen
function love.resize(w, h)
    push:resize(w, h)
end

-- Keyboard entry handler, called each frame
function love.keypressed(key)
    -- When the user presses a key, it gets stored in the table
    love.keyboard.keysPressed[key] = true

    if key == "escape" then
        love.event.quit()
    end

    if key == "p" then
        pause = not pause
    end
end

-- Mouse entry handler, called each frame
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

-- Used to check if a key was pressed in the last frame
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

-- Used to check if a mouse button was pressed in the last frame
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

--Called each frame, updates the game state components
function love.update(dt)
    if not pause then
        -- Scrolling the background and ground sprites
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

        gStateMachine:update(dt)
    end

    -- Resets input table, so it stores only the keys and buttons pressed at one frame
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

-- Called each frame for drawing to the screen after the update or otherwise
function love.draw()
    push:start()

    -- Rendering background, all the items referring to current state and ground
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    -- Visual pause response
    if pause then
        love.graphics.setFont(flappyFont)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("||", 8, 8)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("||", 6, 6)
    end

    push:finish()
end