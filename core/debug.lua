-- DEAL BLOX
-- Sistema de debug

local Debug = {}

function Debug.Log(message)
	print("[DEAL BLOX] " .. tostring(message))
end

function Debug.Warn(message)
	warn("[DEAL BLOX] " .. tostring(message))
end

function Debug.SafeCall(name, callback)
	local success, result = xpcall(callback, debug.traceback)

	if not success then
		warn("[DEAL BLOX] ERRO EM: " .. tostring(name))
		warn(result)
	end

	return success, result
end

return Debug
