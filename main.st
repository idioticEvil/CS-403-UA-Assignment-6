"
ShapeCollection Class
This class is responsible for reading in a list of shapes
from a loaded .dat file, and creating & managing a list
of shape instances from it.
"
Object subclass: #ShapeCollection
    instanceVariableNames: 'shapes'
    classVariableNames: ''
    poolDictionaries: ''.

!ShapeCollection methodsFor: 'initialization'!
initialize
    shapes := OrderedCollection new.
    ^ self
! !

!ShapeCollection methodsFor: 'accessing'!
shapes
    ^ shapes
! !

!ShapeCollection methodsFor: 'file operations'!
loadFromFile: filename
    | fileStream line tokens shape |
    
    fileStream := FileStream open: filename mode: #read ifFail: [
        Transcript show: 'File does not exist'; cr.
        shapes := nil.
        ^ self
    ].
    
    [ [fileStream atEnd] whileFalse: [
            line := fileStream nextLine.
            tokens := line tokenize: ' '.
            tokens isEmpty ifFalse: [
                shape := self createShapeFromTokens: tokens.
                shape ifNotNil: [ shapes add: shape ].
            ].
        ]
    ] ensure: [ fileStream close ].
    
    ^ self
! !

!ShapeCollection methodsFor: 'shape creation'!
createShapeFromTokens: tokens
    | name type shape |
    name := tokens at: 1.
    type := tokens at: 2.

    type = 'box' ifTrue: [
        "Transcript show: 'Created Box: ', name, ' with dimensions: ', 
            (tokens at: 3), ', ', (tokens at: 4), ', ', (tokens at: 5); cr."
        ^ Box name: name
            length: (tokens at: 3) asNumber
            width: (tokens at: 4) asNumber
            height: (tokens at: 5) asNumber
    ].

    type = 'sphere' ifTrue: [
        ^ Sphere name: name
            radius: (tokens at: 3) asNumber
    ].

    type = 'cylinder' ifTrue: [
        ^ Cylinder name: name
            radius: (tokens at: 3) asNumber
            height: (tokens at: 4) asNumber
    ].

    type = 'torus' ifTrue: [
        ^ Torus name: name
            minorRadius: (tokens at: 3) asNumber
            majorRadius: (tokens at: 4) asNumber
    ].

    Transcript show: 'Unknown shape type: ', type; cr.
    ^ nil
! !

"
ShapeApp Class
This class is responsible for managing user interaction with
the shape project. It provides a variety of methods to allow the user
to print information about the shapes and do comparisons.
"
Object subclass: #ShapeApp
    instanceVariableNames: 'shapes'
    classVariableNames: 'ValidActions ValidNames ValidOps'
    poolDictionaries: ''.

!ShapeApp class methodsFor: 'initialization'!
initialize
    ValidActions := #('print' 'count' 'min' 'max' 'total' 'avg').
    ValidNames := #('type' 'area' 'volume').
    ValidOps := #('==' '!=' '>=' '<=' '>' '<').
! !

!ShapeApp class methodsFor: 'running'!
runWith: filename
    | app shapeCollection |
    "Initialize the class first to set up class variables"
    self initialize.
    
    shapeCollection := ShapeCollection new.
    shapeCollection initialize.
    shapeCollection loadFromFile: filename.

    shapeCollection shapes isNil ifTrue: [
        ^ self
    ].

    app := self new.
    app initialize.
    app shapes: shapeCollection shapes.
    app runShell.
! !

!ShapeApp class methodsFor: 'accessing'!
ValidNames
    ^ ValidNames
!

ValidOps
    ^ ValidOps
! !

!ShapeApp methodsFor: 'initialization'!
initialize
    shapes := OrderedCollection new.
    ^ self
! !

!ShapeApp methodsFor: 'accessing'!
shapes: aCollection
    shapes := aCollection.
    ^ self
! !

"Check if the provided action is in the list of valid actions."
!ShapeApp methodsFor: 'validation'!
isValidAction: anAction
    ^ (ValidActions includes: anAction)
        ifTrue: [ 1 ]
        ifFalse: [ -1 ]
!
"Check if the provided name is in the list of valid names."
isValidName: aName
    ^ (ValidNames includes: aName)
        ifTrue: [ 1 ]
        ifFalse: [ -1 ]
!
"Check if the provided operator is in the list of valid operators."
isValidOp: anOp
    ^ (ValidOps includes: anOp)
        ifTrue: [ 1 ]
        ifFalse: [ -1 ]
! !

!ShapeApp methodsFor: 'command parsing'!
extractAction: aString
    | index |
    index := 1.
    [ index <= aString size and: [ (aString at: index) isDigit not ] ]
        whileTrue: [ index := index + 1 ].
    index = 1 ifTrue: [ ^ '' ].  "Handle if first char is a digit"
    ^ aString copyFrom: 1 to: index - 1.
!

extractCount: aString
    | result |
    aString isEmpty ifTrue: [ ^ 0 ].
    
    result := 0.
    1 to: aString size do: [:i |
        (aString at: i) isDigit 
            ifTrue: [ result := (result * 10) + ((aString at: i) digitValue) ]
            ifFalse: [ ^ -1 ].  "Non-digit found"
    ].
    ^ result
!

extractTestConditions: testCount
    | conditions tokens conditionLine name op value |
    conditions := OrderedCollection new.
    1 to: testCount do: [:i |
        [ 
            Transcript show: 'Enter test condition #', i asString, ': '.
            conditionLine := stdin nextLine.
            tokens := conditionLine tokenize: ' '.
            (tokens size >= 3 and: [ (self isValidName: tokens first) = 1 and: [ (self isValidOp: tokens second) = 1 ] ])
        ] whileFalse.
        name := tokens first.
        op := tokens second.
        value := tokens third.
        ((name = 'area') or: [ name = 'volume' ]) ifTrue: [ value := value asNumber ].  "convert numeric values"
        conditions add: name; add: op; add: value.
    ].
    ^ conditions asArray.
! !

!ShapeApp methodsFor: 'shape operations'!
printShapes: conditions
    shapes do: [:shape |
        (shape test: conditions) ifTrue: [
            Transcript show: (shape getInfo); cr.
        ]].
!

countShapes: conditions
    ^ (shapes select: [:shape | shape test: conditions]) size.
!

!ShapeApp methodsFor: 'utility'!
formatToTwoDecimalPlaces: aNumber
    | number str dotIndex |
    "Continue with normal formatting"
    [
        number := (aNumber asFloat * 100) rounded / 100.0.
        str := number printString.
        dotIndex := str indexOf: $. ifAbsent: [str size + 1].
        dotIndex > str size ifTrue: [^ str, '.00'].
        dotIndex = str size ifTrue: [^ str, '00'].
        dotIndex + 1 = str size ifTrue: [^ str, '0'].
        dotIndex + 2 < str size ifTrue: [^ str copyFrom: 1 to: dotIndex + 2].
        ^ str
    ] on: Error do: [:ex |
        Transcript show: 'Error during number formatting: ', ex description; cr.
        ^ 'BAD'
    ]
! !

!ShapeApp methodsFor: 'user interface'!
printHelp
    Transcript
        show: '    count'; cr;
        show: '    *** print the number of all shapes'; cr;
        show: '    countN'; cr;
        show: '    *** print the number of all shapes that satisfy all N conditions specified below'; cr;
        show: '    *** for example: count3'; cr;
        show: '    print'; cr;
        show: '    *** print all shapes'; cr;
        show: '    printN'; cr;
        show: '    *** print all shapes that satisfy all N conditions specified below'; cr;
        show: '    *** for example: print4'; cr;
        show: '    min'; cr;
        show: '    *** find the minimum surface area and volume of all shapes'; cr;
        show: '    minN'; cr;
        show: '    *** find the minimum surface area and volume of all shapes that satisfy all N conditions specified below'; cr;
        show: '    *** for example: min2'; cr;
        show: '    max'; cr;
        show: '    *** find the maximum surface area and volume of all shapes'; cr;
        show: '    maxN'; cr;
        show: '    *** find the maximum surface area and volume of all shapes that satisfy all N conditions specified below'; cr;
        show: '    *** for example: max3'; cr;
        show: '    total'; cr;
        show: '    *** find the total surface area and volume of all shapes'; cr;
        show: '    totalN'; cr;
        show: '    *** find the total surface area and volume of all shapes that satisfy all N conditions specified below'; cr;
        show: '    *** for example: total4'; cr;
        show: '    avg'; cr;
        show: '    *** find the average surface area and volume of all shapes'; cr;
        show: '    avgN'; cr;
        show: '    *** find the average surface area and volume of all shapes that satisfy all N conditions specified below'; cr;
        show: '    *** for example: avg2'; cr;
        show: '    quit'; cr;
        show: '    *** quit this program'; cr;
        show: '    help'; cr;
        show: '    *** print this list'; cr; cr.
    Transcript
        show: 'Each condition shall be entered in one line and of the following format:'; cr;
        show: '    name op value'; cr; cr;
        show: '    *** for example: type != box'; cr;
        show: '    ***              area <= 1000'; cr;
        show: '    ***              volume > 100.5'; cr; cr;
        show: 'The valid names:'; cr.
    ShapeApp ValidNames do: [:name | Transcript show: '        ', name; cr].
    Transcript show: 'The valid operators:'; cr.
    ShapeApp ValidOps do: [:op | Transcript show: '        ', op; cr].
    Transcript cr.
!

runShell
    "Runs the main command loop for the application."
    | command action testCount conditions count areaMin volMin area vol totalArea totalVol |
    [ true ] whileTrue: [
        Transcript show: 'Enter a command: '.
        command := stdin nextLine.
        
        "If the command is 'quit' or 'exit', leave the loop."
        (command = 'quit' or: [ command = 'exit' ])
            ifTrue: [ ^ self ]
            ifFalse: [].
        
        "If the user asks for help, display the help message."
        command = 'help'
            ifTrue: [
                self printHelp.
                "Return to start the loop over"
                ^ self runShell
            ]
            ifFalse: [].
        
        "Extract the action (e.g., 'print' from 'print3') and the count suffix"
        action := self extractAction: command.
        testCount := self extractCount: (command copyFrom: action size + 1 to: command size).
        
        "Validate the action and count"
        ((self isValidAction: action) = -1 or: [ testCount < 0 ])
            ifTrue: [
                Transcript show: action, ': invalid action'; cr.
                Transcript show: 'Valid actions: ', (ShapeApp ValidActions joinSeparatedBy: ' '); cr.
                Transcript show: 'Enter help for help'; cr.
                ^ self runShell
            ]
            ifFalse: [].
        
        "Dispatch the command based on the action"
        action = 'count'
            ifTrue: [
                conditions := self extractTestConditions: testCount.
                count := self countShapes: conditions.
                Transcript show: 'There are ', count printString, ' shapes.'; cr.
            ]
            ifFalse: [
                action = 'print'
                    ifTrue: [
                        conditions := self extractTestConditions: testCount.
                        count := self countShapes: conditions.
                        count = 0
                            ifTrue: [ Transcript show: 'There are no shapes satisfying the condition(s)'; cr ]
                            ifFalse: [ self printShapes: conditions ].
                    ]
                    ifFalse: [
                        action = 'min'
                            ifTrue: [
                                conditions := self extractTestConditions: testCount.
                                count := self countShapes: conditions.
                                count = 0
                                    ifTrue: [ Transcript show: 'There are no shapes satisfying the condition(s)'; cr ]
                                    ifFalse: [
                                        areaMin := 1.0/0.0.   
                                        volMin := 1.0/0.0.   
                                        shapes do: [:shape |
                                            (shape test: conditions) ifTrue: [
                                                area := shape getArea.
                                                vol := shape getVolume.
                                                area < areaMin ifTrue: [ areaMin := area ] ifFalse: [].
                                                vol < volMin ifTrue: [ volMin := vol ] ifFalse: [].
                                            ] ifFalse: [].
                                        ].
                                        Transcript show: 'min(Surface Area)=', (self formatToTwoDecimalPlaces: areaMin); cr.
                                        Transcript show: 'min(Volume)=', (self formatToTwoDecimalPlaces: volMin); cr.
                                    ].
                            ]
                            ifFalse: [
                                action = 'max'
                                    ifTrue: [
                                        conditions := self extractTestConditions: testCount.
                                        count := self countShapes: conditions.
                                        count = 0
                                            ifTrue: [ Transcript show: 'There are no shapes satisfying the condition(s)'; cr ]
                                            ifFalse: [
                                                areaMin := -1.0/0.0.   "Changed from: Float negInfinity"
                                                volMin := -1.0/0.0.    "Changed from: Float negInfinity"
                                                shapes do: [:shape |
                                                    (shape test: conditions) ifTrue: [
                                                        area := shape getArea.
                                                        vol := shape getVolume.
                                                        area > areaMin ifTrue: [ areaMin := area ] ifFalse: [].
                                                        vol > volMin ifTrue: [ volMin := vol ] ifFalse: [].
                                                    ] ifFalse: [].
                                                ].
                                                Transcript show: 'max(Surface Area)=', (self formatToTwoDecimalPlaces: areaMin); cr.
                                                Transcript show: 'max(Volume)=', (self formatToTwoDecimalPlaces: volMin); cr.
                                            ].
                                    ]
                                    ifFalse: [
                                        (action = 'total' or: [ action = 'avg' ])
                                            ifTrue: [
                                                conditions := self extractTestConditions: testCount.
                                                count := self countShapes: conditions.
                                                count = 0
                                                    ifTrue: [ Transcript show: 'There are no shapes satisfying the condition(s)'; cr ]
                                                    ifFalse: [
                                                        totalArea := 0.
                                                        totalVol := 0.
                                                        shapes do: [:shape |
                                                            (shape test: conditions) ifTrue: [
                                                                totalArea := totalArea + (shape getArea).
                                                                totalVol := totalVol + (shape getVolume).
                                                            ] ifFalse: [].
                                                        ].
                                                        action = 'total'
                                                            ifTrue: [
                                                                Transcript show: 'area=', (self formatToTwoDecimalPlaces: totalArea); cr.
                                                                Transcript show: 'vol=', (self formatToTwoDecimalPlaces: totalVol); cr.
                                                            ]
                                                            ifFalse: [
                                                                Transcript show: 'area=', (self formatToTwoDecimalPlaces: totalArea / count); cr.
                                                                Transcript show: 'vol=', (self formatToTwoDecimalPlaces: totalVol / count); cr.
                                                            ].
                                                    ].
                                            ]
                                            ifFalse: [].
                                    ].
                            ].
                    ].
            ].
    ].
! !

"Run the application with the filename from command line"
Smalltalk arguments size >= 1
    ifTrue: [ShapeApp runWith: Smalltalk arguments first]
    ifFalse: [
        Transcript show: 'Incorrect number of arguments'; cr.
    ].