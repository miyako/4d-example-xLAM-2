property tools : Collection

shared singleton Class constructor
	
	var $tools : Collection
	$tools:=[]
	
	var $OpenAITool : cs:C1710.AIKit.OpenAITool
	
	$OpenAITool:=cs:C1710.AIKit.OpenAITool.new({\
		type: "function"; \
		function: {\
		name: "currentDate"; \
		description: "The Current date command returns the current date as kept by the system clock."; \
		parameters: {\
		type: "object"; \
		properties: {}}}})
	
	$tools.push($OpenAITool)
	
	$OpenAITool:=cs:C1710.AIKit.OpenAITool.new({\
		type: "function"; \
		function: {\
		name: "currentTime"; \
		description: "The Current time command returns the current time from the system clock."; \
		parameters: {\
		type: "object"; \
		properties: {}}}})
	
	$tools.push($OpenAITool)
	
	$OpenAITool:=cs:C1710.AIKit.OpenAITool.new({\
		type: "function"; \
		function: {\
		name: "currentUser"; \
		description: "Current user returns the alias or account name of the current user."; \
		parameters: {\
		type: "object"; \
		properties: {}}}})
	
	$tools.push($OpenAITool)
	
	This:C1470.tools:=$tools.copy(ck shared:K85:29)
	
Function currentDate($object : Object) : Object
	
	return {date: String:C10(Current date:C33; ISO date:K1:8)}
	
Function currentTime($object : Object) : Object
	
	return {time: String:C10(Current time:C178; HH MM SS:K7:1)}
	
Function currentUser($object : Object) : Object
	
	return {user: Current user:C182}