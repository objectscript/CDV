# IDP DV
Class data verifier. Utility validates IRIS classes properties data according to the properties' types.

## Instalation

To install IDP.DV, you just need to dowload and import the package [IDP.DV](https://github.com/intersystems-ru/CDV/releases) file.
Some ways to import IDP package:
- Go to Management Portal -> System Explorer -> Classes -> Import and select the XML file.
- Drag the file over Studio
- Terminal command:

```
Do $system.OBJ.Load("yourpath/IDP.DV.xml","ck")
```

## Docker

To install using Docker. Follow this instructions:

Open terminal and clone the repo into any local directory

```
$ git https://github.com/intersystems-ru/CDV.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

Run the IRIS container with your project:
```
$ docker-compose up -d
```

### How to Run the Application
Open InterSystems IRIS terminal:

```
$ docker-compose exec iris iris session iris
USER>zn "IRISAPP"
IRISAPP>set st = ##class(IDP.DV).ScanAllClasses(.Oid)
IRISAPP>zw Oid
```

## Usage 

    s st = ##class(IDP.DV).ScanAllClasses(.Oid) - for all user classes
    s st = ##class(IDP.DV).ScanSubclassesOf(Class, .Oid) - for subclasses
    s st = ##class(IDP.DV).ScanMatchingClasses(Mask, .Oid) - for LIKE SQL
    
The utility works only in a current namespace.

Arguments:

- `Oid` - Output structure, that stores data about invalid objects in a classes
- `Class` - Scan all subclasses Of a class (and class itself).
- `Mask` - Passed into the SQL query `SELECT ID FROM %Dictionary.ClassDefinition Where ID LIKE ?`


    
