property text : Text
property reasoning_content : Text
property tool_calls : Collection

Class constructor
	
Function step1($ChatCompletionsResult : cs:C1710.AIKit.OpenAIChatCompletionsResult)
	
	If ($ChatCompletionsResult.success)
		If ($ChatCompletionsResult.terminated)
			
			var $Tools : cs:C1710.Tools
			$Tools:=cs:C1710.Tools.me
			
			$messages:=Form:C1466.messages
			
			Case of 
				: ($ChatCompletionsResult.choice.finish_reason="length")
					
				: ($ChatCompletionsResult.choice.finish_reason="stop")
					
				: ($ChatCompletionsResult.choice.finish_reason="tool_calls")
					
					For each ($tool_call; Form:C1466.tool_calls)
						$arguments:=JSON Parse:C1218($tool_call.function.arguments)
						$tool_call.content:=$Tools[$tool_call.function.name].call($OpenAI; $arguments)
						
						$messages.push({\
							role: "tool"; \
							tool_call_id: $tool_call.id; \
							name: $tool_call.function.name; \
							content: JSON Stringify:C1217($tool_call.content)})
					End for each 
					
					var $ChatCompletionsParameters : cs:C1710.AIKit.OpenAIChatCompletionsParameters
					$ChatCompletionsParameters:=cs:C1710.AIKit.OpenAIChatCompletionsParameters.new()
					
					//parameters for tool calling
					$ChatCompletionsParameters.temperature:=0.1
					$ChatCompletionsParameters.tool_choice:="auto"
					$ChatCompletionsParameters.tools:=$Tools.tools
					$ChatCompletionsParameters.stream:=True:C214
					$ChatCompletionsParameters.formula:=Form:C1466.step1
					
					Form:C1466.text:=""
					Form:C1466.reasoning_content:=""
					Form:C1466.tool_calls:=[]
					
					var $OpenAI : cs:C1710.AIKit.OpenAI
					$OpenAI:=cs:C1710.AIKit.OpenAI.new()
					$OpenAI.baseURL:="http://127.0.0.1:8080/v1"
					$OpenAI.chat.completions.create($messages; $ChatCompletionsParameters)
					
			End case 
			
		Else 
			var $end : Integer
			If ($ChatCompletionsResult.choice.delta.text#Null:C1517)
				Form:C1466.text+=$ChatCompletionsResult.choice.delta.text
				$end:=Length:C16(Form:C1466.text)+1
				HIGHLIGHT TEXT:C210(*; "text"; $end; $end)
			End if 
			If ($ChatCompletionsResult.choice.delta["reasoning_content"]#Null:C1517)
				Form:C1466.reasoning_content+=$ChatCompletionsResult.choice.delta["reasoning_content"]
				$end:=Length:C16(Form:C1466.reasoning_content)+1
				HIGHLIGHT TEXT:C210(*; "reasoning_content"; $end; $end)
			End if 
			If ($ChatCompletionsResult.choice.delta.tool_calls#Null:C1517)
				For each ($tool_call; $ChatCompletionsResult.choice.delta.tool_calls)
					var $tool : Object
					$tool:=Form:C1466.tool_calls.query("index == :1"; $tool_call.index).first()
					If ($tool=Null:C1517)
						$tool:=OB Copy:C1225($tool_call)
						Form:C1466.tool_calls.push($tool)
					Else 
						$tool.function.arguments+=$tool_call.function.arguments
					End if 
				End for each 
			End if 
		End if 
	End if 
	
Function demo()
	
	var $Tools : cs:C1710.Tools
	$Tools:=cs:C1710.Tools.me
	
	var $messages : Collection
	$messages:=[]
	$messages.push({role: "system"; content: "Use them to answer the user's questions. All tools apply to the current system and location. "})
	$messages.push({role: "user"; content: "What day and time is it? Also who is the current user?"})
	
	var $ChatCompletionsParameters : cs:C1710.AIKit.OpenAIChatCompletionsParameters
	$ChatCompletionsParameters:=cs:C1710.AIKit.OpenAIChatCompletionsParameters.new()
	
	//parameters for tool calling
	$ChatCompletionsParameters.temperature:=0.1
	$ChatCompletionsParameters.tool_choice:="auto"
	$ChatCompletionsParameters.tools:=$Tools.tools
	$ChatCompletionsParameters.stream:=True:C214
	$ChatCompletionsParameters.formula:=Form:C1466.step1
	
	Form:C1466.text:=""
	Form:C1466.reasoning_content:=""
	Form:C1466.tool_calls:=[]
	
	var $OpenAI : cs:C1710.AIKit.OpenAI
	$OpenAI:=cs:C1710.AIKit.OpenAI.new()
	$OpenAI.baseURL:="http://127.0.0.1:8080/v1"
	$OpenAI.chat.completions.create($messages; $ChatCompletionsParameters)
	
	Form:C1466.messages:=$messages