//%attributes = {}
var $LLM : cs:C1710.LLM
$LLM:=cs:C1710.LLM.me

If ($LLM.available)
	Form:C1466.progress:=100
Else 
	var $progress : Collection
	$progress:=[]
	var $file : Text
	For each ($file; $LLM.files)
		$progress.push($LLM.files[$file].progress*100)
	End for each 
	OBJECT SET VISIBLE:C603(*; "progress"; True:C214)
	Form:C1466.progress:=$progress.average()
End if 

OBJECT SET VISIBLE:C603(*; "progress"; Not:C34($LLM.available))
OBJECT SET VISIBLE:C603(*; "btn.@"; $LLM.available)