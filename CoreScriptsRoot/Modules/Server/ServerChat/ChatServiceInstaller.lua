local runnerScriptName = "ChatServiceRunner"

local installDirectory = game:GetService("Chat")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local function LoadScript(name, parent)
	local originalModule = script.Parent:WaitForChild(name)
	local script = Instance.new("Script")
	script.Name = name
	script.Source = originalModule.Source
	script.Parent = parent
	return script
end

local function LoadModule(location, name, parent)
	local originalModule = location:WaitForChild(name)
	local module = Instance.new("ModuleScript")
	module.Name = name
	module.Source = originalModule.Source
	module.Parent = parent
	return module
end

local function Install()

	local chatServiceRunnerArchivable = true
	local ChatServiceRunner = installDirectory:FindFirstChild(runnerScriptName)
	if not ChatServiceRunner then
		chatServiceRunnerArchivable = false
		ChatServiceRunner = LoadScript(runnerScriptName, installDirectory)

		LoadModule(script.Parent, "ChatService", ChatServiceRunner)
		LoadModule(script.Parent, "ChatChannel", ChatServiceRunner)
		LoadModule(script.Parent, "Speaker", ChatServiceRunner)
		LoadModule(script.Parent.Parent.Parent.Common, "ClassMaker", ChatServiceRunner)
	end

	local chatModulesArchivable = true
	local ChatModules = installDirectory:FindFirstChild("ChatModules")
	if not ChatModules then
		chatModulesArchivable = false
		ChatModules = Instance.new("Folder")
		ChatModules.Name = "ChatModules"

		LoadModule(script.Parent.DefaultChatModules, "ExtraDataInitializer", ChatModules)
		LoadModule(script.Parent.DefaultChatModules, "ChatCommandsTeller", ChatModules)
		LoadModule(script.Parent.DefaultChatModules, "ChatFloodDetector", ChatModules)
		LoadModule(script.Parent.DefaultChatModules, "PrivateMessaging", ChatModules)
		LoadModule(script.Parent.DefaultChatModules, "TeamChat", ChatModules)

		ChatModules.Parent = installDirectory
	end

	if not ServerScriptService:FindFirstChild("ChatModules") then
		local ChatModulesCopy = ChatModules:Clone()
		ChatModulesCopy.Parent = ServerStorage
		ChatModulesCopy.Archivable = false
	end

	if not ServerScriptService:FindFirstChild(runnerScriptName) then
		local ChatServiceRunnerCopy = ChatServiceRunner:Clone()
		ChatServiceRunnerCopy.Archivable = false
		ChatServiceRunnerCopy.Parent = ServerScriptService
	end

	ChatServiceRunner.Archivable = chatServiceRunnerArchivable
	ChatModules.Archivable = chatModulesArchivable
end

return Install