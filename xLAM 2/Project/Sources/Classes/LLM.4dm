property files : Object
property available : Boolean
property window : Integer
property formula : 4D:C1709.Function

shared singleton Class constructor($folder : 4D:C1709.Folder; \
$path : Text; $URL : Text; \
$window : Integer; $formula : 4D:C1709.Function)
	
	This:C1470.window:=$window
	This:C1470.formula:=$formula
	
	var $event : cs:C1710.event.event
	$event:=cs:C1710.event.event.new()
	$event.onError:=This:C1470.onError
	$event.onSuccess:=This:C1470.onSuccess
	$event.onData:=This:C1470.onData
	$event.onResponse:=This:C1470.onResponse
	$event.onTerminate:=This:C1470.onTerminate
	
	This:C1470.files:=New shared object:C1526
	This:C1470.available:=False:C215
	
	var $port : Integer
	$port:=8080
	
	var $options : Object
	$options:={}
	
	var $huggingface : cs:C1710.event.huggingface
	$huggingface:=cs:C1710.event.huggingface.new($folder; $URL; $path; "chat")
	var $huggingfaces : cs:C1710.event.huggingfaces
	$huggingfaces:=cs:C1710.event.huggingfaces.new([$huggingface])
	
	var $CTranslate2 : cs:C1710.CTranslate2.CTranslate2
	$CTranslate2:=cs:C1710.CTranslate2.CTranslate2.new($port; $huggingfaces; $folder.parent; $options; $event)
	
shared Function onTerminate($process : Object)
	
	LOG EVENT:C667(Into 4D debug message:K38:5; (["process"; $process.pid; "terminated!"].join(" ")))
	
	var $that:=cs:C1710.LLM.me
	Use ($that)
		$that.available:=False:C215
	End use 
	
	CALL FORM:C1391($that.window; $that.formula)
	
shared Function onResponse()
	
	var $this : Object
	$this:=This:C1470
	
	LOG EVENT:C667(Into 4D debug message:K38:5; $this.file.fullName+":download complete")
	
	var $that:=cs:C1710.LLM.me
	
	Use ($that)
		var $file : Object
		$file:=$that.files[$this.file.fullName]
		If ($file=Null:C1517)
			$file:=New shared object:C1526("downloaded"; False:C215)
			$that.files[$this.file.fullName]:=$file
		End if 
		$file.downloaded:=True:C214
		$file.progress:=100
	End use 
	
	CALL FORM:C1391($that.window; $that.formula)
	
shared Function onData()
	
	var $this : Object
	$this:=This:C1470
	var $progress : Real
	$progress:=$this.range.end/$this.range.length
	LOG EVENT:C667(Into 4D debug message:K38:5; $this.file.fullName+":"+String:C10($progress*100; "###.00%"))
	
	var $that:=cs:C1710.LLM.me
	
	Use ($that)
		var $file : Object
		$file:=$that.files[$this.file.fullName]
		If ($file=Null:C1517)
			$file:=New shared object:C1526("downloaded"; False:C215)
			$that.files[$this.file.fullName]:=$file
		End if 
		$file.progress:=$progress
	End use 
	
	CALL FORM:C1391($that.window; $that.formula)
	
Function onError($options : Object; $error : Object)
	
	ALERT:C41($error.message)
	
shared Function onSuccess($options : Object; $env : Object)
	
	var $that:=cs:C1710.LLM.me
	Use ($that)
		$that.available:=True:C214
	End use 
	
	CALL FORM:C1391($that.window; $that.formula)