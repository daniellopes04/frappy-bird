--[[
    Part of "S50's Intro to Game Development"
    Lecture 1
    
    -- StateMachine Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04

    Code taken and edited from lessons in http://howtomakeanrpg.com

    Usage:

	States are only created as need, to save memory, reduce clean-up bugs and increase speed
	due to garbage collection taking longer with more data in memory.

	States are added with a string identifier and an intialisation function.
	It is expected the init function, when called, will return a table with
	Render, Update, Enter and Exit methods.

	gStateMachine = StateMachine {
			['MainMenu'] = function()
				return MainMenu()
			end,
			['InnerGame'] = function()
				return InnerGame()
			end,
			['GameOver'] = function()
				return GameOver()
			end,
	}
	gStateMachine:change("MainGame")

	Arguments passed into the Change function after the state name
	will be forwarded to the Enter function of the state being changed too.

	State identifiers should have the same name as the state table, unless there's a good
	reason not to. i.e. MainMenu creates a state using the MainMenu table. This keeps things
	straight forward. 
]]

StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		enter = function() end,
		exit = function() end,
		update = function() end,
		render = function() end
	}
	self.states = states or {} 
	self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName])
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end