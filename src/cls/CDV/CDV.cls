Class CDV.CDV
{

ClassMethod ScanFromAllClasses() As %Status
{
	#Dim sc As %Status = $$$OK
	set sc = $System.OBJ.GetClassList(.Classes, "/application=0 /system=0 /percent=0 /mapped=0")
	Quit:$$$ISERR(sc)
	Set sc = ..ScanFromClassLocal(.Classes)
	Quit sc
}

ClassMethod ScanFromSubclassesOf(Class As %String) As %Status
{
	#Dim sc As %Status = $$$OK
	Set RS = ##class(%ResultSet).%New("%Dictionary.ClassDefinition:SubclassOf")
	Set sc = RS.%Execute(Class)
	Quit:$$$ISERR(sc) 
	
	Set Classes(Class) = ""

	While (RS.%Next(.sc)) {
		Quit:$$$ISERR(sc)		
		Set Classes(RS.Data("Name")) = ""
	}
	
	Set sc = ..ScanFromClassLocal(.Classes)
	Quit sc
}

ClassMethod ScanFromMatchingClasses(Mask As %String) As %Status
{
	#Dim sc As %Status = $$$OK
	
	Set SQL = "SELECT ID FROM %Dictionary.ClassDefinition Where ID LIKE ?"
	Set ST = ##class(%SQL.Statement).%New()
	Set sc = ST.%Prepare(SQL)
	Quit:$$$ISERR(sc) sc
	
	#Dim RS As %SQL.StatementResult
	Set RS = ST.%Execute(Mask)
	
	While RS.%Next() {
		Set Classes(RS.%GetData(1)) = ""
	}
	
	Set sc = ..ScanFromClassLocal(.Classes)
	Quit sc
}

ClassMethod ScanFromClassLocal(ByRef Classes As %String) As %Status
{
	#Dim sc,sc1 As %Status = $$$OK
	Set Class = ""
	For { 
		Set Class = $Order(Classes(Class))
		Quit:Class=""
		If ($classmethod(Class, "%Extends", "%RegisteredObject"))
		{
			Set sc1 = ..ValidateClassObjects(Class)
		}
		Set sc = $$$ADDSC(sc, sc1)		
	}
	
	Quit sc
}

ClassMethod ValidateClassObjects(Class As %String) As %Status
{
	#Dim sc As %Status = $$$OK

	set Oid = Class
	set query = ##class(%SQL.Statement).%New()
    set status= query.%PrepareClassQuery(Class,"Extent")
    if 'status 
    {
    	do $system.OBJ.DisplayError(status)
 	}
 	set rset=query.%Execute()

	While (rset.%Next()) 
	{
    	set obj = $classmethod(Class, "%OpenId", rset.%Get("ID"))
    	set Oid(Class,rset.%Get("ID")) = obj.%ValidateObject()
    	Kill obj
 	}
	
	zw Oid
	Quit sc
}

}

