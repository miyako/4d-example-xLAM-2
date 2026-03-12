property tools : Collection

shared singleton Class constructor
	
	var $tools : Collection
	$tools:=[]
	
	var $OpenAITool : cs:C1710.AIKit.OpenAITool
	
	$OpenAITool:=cs:C1710.AIKit.OpenAITool.new({\
		type: "function"; \
		function: {\
		name: "CurrentMachine"; \
		description: "The Current machine command returns the name of the machine as set in the network parameters of the operating system."; \
		parameters: {\
		type: "object"; \
		properties: {}}}})
	
	$tools.push($OpenAITool)
	
	This:C1470.tools:=$tools.copy(ck shared:K85:29)
	
Function CurrentMachine($object : Object) : Text
	
	return Current machine:C483
	
	