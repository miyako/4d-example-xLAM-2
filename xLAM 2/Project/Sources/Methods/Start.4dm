//%attributes = {}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(1; Current method name:C684; {})
	
Else 
	
	var $TEST : cs:C1710.TEST
	$TEST:=cs:C1710.TEST.new()
	
	var $window : Integer
	$window:=Open form window:C675("TEST")
	DIALOG:C40("TEST"; $TEST; *)
	
End if 