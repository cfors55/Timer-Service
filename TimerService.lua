--!strict
local ServerStorage = game:GetService("ServerStorage")

local TimerService = {}
TimerService._cache = {}
local TimerObject = {}

type TimerObject = {
	Name:string,
	Enabled:boolean,
	Hours:number,
	Minutes:number,
	Seconds:number,
	TotalSeconds:number,
	TimerEnded:BindableEvent,
	Destroy: (self:TimerObject)->(),
}

type _TimerObject = TimerObject & {
	_thread:thread
}

type TimerService = {
	new: (name:string,totalSeconds:number)->TimerObject,
	GetTimer: (name:string)->TimerObject?,
}

--Returns a <strong>Timer Object</strong> given <strong>Name</strong>.
function TimerService:GetTimer(name:string):TimerObject?
	return TimerService._cache[name]
end

local mt = {
	__index = TimerObject
}

--Creates a new <strong>Timer Object</strong> given <strong>Name</strong> and <strong>Seconds</strong>.
function TimerService.new(name:string,totalSeconds:number):TimerObject
	local self:_TimerObject = setmetatable({},mt) :: any
	self.Name = name
	self.TotalSeconds = totalSeconds
	self.Hours = math.floor(totalSeconds/3600)
	self.Minutes = math.floor((totalSeconds%3600) / 60)
	self.Seconds = totalSeconds % 60
	self.Enabled = false
	local TimerEnded = Instance.new("BindableEvent")
	local TimerFolder = ServerStorage:FindFirstChild("TimerFolder")
	TimerEnded.Name = name
	if not TimerFolder then
		TimerFolder = Instance.new("Folder")
		TimerFolder.Name = "TimerFolder"
		TimerFolder.Parent = ServerStorage
	end
	TimerEnded.Parent = TimerFolder
	self.TimerEnded = TimerEnded
	self._thread = task.spawn(init,self)
	TimerService._cache[name] = self
	return self
end

function updateTimeData(self:TimerObject)
	self.Hours = math.floor(self.TotalSeconds/3600)
	self.Minutes = math.floor((self.TotalSeconds%3600) / 60)
	self.Seconds = self.TotalSeconds % 60
end

function init(self:TimerObject)
	local last = os.clock()
	while true do
		if not self.TotalSeconds or self.TotalSeconds <= 0 then
			self.TotalSeconds = 0
			self.Enabled = false
			updateTimeData(self)
			break 
		end
		local now = os.clock()
		local dt = now - last
		last = now
		if self.Enabled then
			self.TotalSeconds -= dt
			updateTimeData(self) 
			if self.TotalSeconds <= 0 then
				self.TotalSeconds = 0
				self.Enabled = false
				break
			end
		end
		task.wait(0.1) 
	end
	self.TimerEnded:Fire()	
end

--Destroys the <strong>Timer Object</strong>.
function TimerObject.Destroy(self:TimerObject):()
	self.Enabled = false
	self.TimerEnded:Destroy()
	task.cancel(TimerService._cache[self.Name]._thread)
	TimerService._cache[self.Name] = nil
	setmetatable(self,nil)
	table.clear(self)
end

return TimerService::TimerService


