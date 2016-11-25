# CDV
Class data verifier. Utility validates Caché classes properties data according the properties type.


##Use
Import classes and call one of the entry points: 

    s st = ##class(CDV.CDV).ScanFromAllClasses(.Oid) - for all user classes
    s st = ##class(CDV.CDV).ScanFromSubclassesOf(Class, .Oid) - for subclasses
    s st = ##class(CDV.CDV).ScanFromMatchingClasses(Mask, .Oid) - for LIKE SQL
    
The utility works only in a current namespace.

Arguments:

- `Oid` - Output structure, that stores data about invalid objects in a classes
- `Class` - Scan all subclasses Of a class (and class itself).
- `Mask` - Passed into the SQL query `SELECT ID FROM %Dictionary.ClassDefinition Where ID LIKE ?`

##Exemple

1. Import CDV.CDV into desired namespace
2. Run in terminal:

        s st = ##class(CDV.CDV).ScanFromAllClasses(.Oid)
        zw Oid

    
