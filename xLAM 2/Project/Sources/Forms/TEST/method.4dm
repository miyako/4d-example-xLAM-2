var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		var $LLM : cs:C1710.LLM
		$LLM:=cs:C1710.LLM.new(\
			Folder:C1567(fk home folder:K87:24).folder(".CTranslate2").folder("Arch-Agent-1.5B"); \
			"Arch-Agent-1.5B-ct2-int8"; \
			"keisuke-miyako/Arch-Agent-1.5B-ct2-int8"; \
			Current form window:C827; Formula:C1597(OnLLM))
		
		OBJECT SET VISIBLE:C603(*; "progress"; Not:C34($LLM.available))
		OBJECT SET VISIBLE:C603(*; "btn.@"; $LLM.available)
		
End case 