Class CDV.CDV
{

ClassMethod ScanAllClasses(ByRef Oid As %String) As %Status
{
	#Dim sc As %Status = $$$OK
	set sc = $System.OBJ.GetClassList(.Classes, "/application=0 /system=0 /percent=0 /mapped=0")
	Quit:$$$ISERR(sc)
	Set sc = ..ScanClassLocal(.Classes, .Oid)
	Quit sc
}

ClassMethod ScanSubclassesOf(Class As %String, ByRef Oid As %String) As %Status
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
	
	Set sc = ..ScanClassLocal(.Classes, .Oid)
	Quit sc
}

ClassMethod ScanMatchingClasses(Mask As %String, ByRef Oid As %String) As %Status
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
	
	Set sc = ..ScanClassLocal(.Classes, .Oid)
	Quit sc
}

ClassMethod ScanClassLocal(ByRef Classes As %String, ByRef Oid As %String) As %Status
{
	#Dim sc,sc1 As %Status = $$$OK
	Set Class = ""
	For { 
		Set Class = $Order(Classes(Class))
		Quit:Class=""
		If (##class(%Dictionary.CompiledClass).%ExistsId(Class) && $classmethod(Class, "%Extends", "%Library.Persistent"))
		{
			Set sc1 = ..ValidateClassObjects(Class, .Oid)
		}
		Set sc = $$$ADDSC(sc, sc1)		
	}
	
	Quit sc
}

ClassMethod ValidateClassObjects(Class As %String, ByRef Oid As %String) As %Status
{
	#Dim sc As %Status = $$$OK
	
	w !,"__________________________________________________________________________________",!
	set Oid(Class) = 0
	set query = ##class(%SQL.Statement).%New()
    set sc = query.%PrepareClassQuery(Class,"Extent")
    return:$$$ISERR(sc) sc
 	set rset=query.%Execute()

	While (rset.%Next()) 
	{
    	set obj = $classmethod(Class, "%OpenId", rset.%Get("ID"))
		do $system.CLS.SetModified(obj, 1)
		w !,"Class: ",Class,!,"Object: ", rset.%Get("ID"),!
		w "-----------------------------------------------"
    	set valid = $system.Status.DisplayError(obj.%ValidateObject())
    	w !,!,!
    	
    	if (valid)
    	{ 
    		set Oid(Class) = Oid(Class) + 1
    		set Oid(Class, rset.%Get("ID")) = "Invalide"
    	}
    	Kill obj, valid
 	}
 	w !,Class, " has ",Oid(Class)," invalid objects "
	Quit sc
}
}

