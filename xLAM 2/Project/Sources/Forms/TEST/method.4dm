var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		var $LLM : cs:C1710.LLM
		$LLM:=cs:C1710.LLM.new(\
			Folder:C1567(fk home folder:K87:24).folder(".GGUF").folder("xLAM-2-3b-fc-r"); \
			"xLAM-2-3b-fc-r-Q4_k_m.gguf"; \
			"keisuke-miyako/xLAM-2-3b-fc-r-gguf-q4_k_m"; 32000; 1; 2; \
			Current form window:C827; Formula:C1597(OnLLM))
		
		OBJECT SET VISIBLE:C603(*; "progress"; Not:C34($LLM.available))
		OBJECT SET VISIBLE:C603(*; "btn.@"; $LLM.available)
		
End case 