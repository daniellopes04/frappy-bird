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

-- Pipe class
require "Pipe"

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

-- Seed the random number generator function
math.randomseed(os.time())

-- Bird sprite and pipes sprite list
local bird = Bird()
local pipes = {}

-- Keeps track of the elapsed time since last pipe spawn
local spawnTimer = 0

-- Runs when the game starts, only once
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Frappy Bird")

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

    -- Spawn a pipe every 2 seconds on the edge of screen
    spawnTimer = spawnTimer + dt

    if spawnTimer > 2 then
        table.insert(pipes, Pipe())
        spawnTimer = 0
    end

    -- Moves the bird and flaps its wings
    bird:update(dt)

    -- Moves pipes through the screen 
    for k, pipe in pairs(pipes) do
        pipe:update(dt)

        if pipe.x < -pipe.width then
            table.remove(pipes, k)
        end
    end

    -- Resets input table, so it stores only the keys pressed at one frame
    love.keyboard.keysPressed = {}
end

-- Called each frame for drawing to the screen after the update or otherwise
function love.draw()
    push:start()

    -- Rendering background
    love.graphics.draw(background, -backgroundScroll, 0)

    -- Rendering all the pipes
    for k, pipe in pairs(pipes) do
        pipe:render()
    end

    -- Rendering ground after the pipes, so the pipes appear to be sticking out of it
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    -- Rendering the bird
    bird:render()

    push:finish()
end