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

-- Bird class
require "Bird"

-- Screen's real and virtual dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

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

local bird = Bird()

-- Runs when the game starts, only once
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Frappy Bird")

    -- Changes the background and ground sprites based on hour of day
    currentHour = tonumber(os.date("%H"))
    if currentHour >= 18 or (currentHour >= 0 and currentHour <= 6) then
        background = love.graphics.newImage("sprites/background-night.png")
        ground = love.graphics.newImage("sprites/ground-night.png")
    elseif currentHour == 17 or currentHour == 18 then
        background = love.graphics.newImage("sprites/background-sunset.png")
    end

    -- Setting up the screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- Keeps track of the keys pressed by the user
    love.keyboard.keysPressed = {}
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
end

-- Used to check if a key was pressed in the last frame
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--Called each frame, updates the game state components
function love.update(dt)
    -- Scrolling the background and ground sprites
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    -- Moves the bird and flaps its wings
    bird:update(dt)

    -- Resets the table, so it stores only the keys pressed at one frame
    love.keyboard.keysPressed = {}
end

-- Called each frame for drawing to the screen after the update or otherwise
function love.draw()
    push:start()

    -- Rendering background and foreground
    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    -- Rendering the bird
    bird:render()

    push:finish()
end