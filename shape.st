"Shape class definition
This class serves as a base class for different shapes.
It provides methods to set and get the name of the shape,
and abstract methods for getting type, area, volume, and info.
Subclasses will implement these abstract methods."

Object subclass: #Shape
    instanceVariableNames: 'name'
    classVariableNames: ''
    poolDictionaries: ''.

!Shape class methodsFor: 'instance creation'!
name: aString
    ^ self new setName: aString
! !

!Shape methodsFor: 'accessing'!
setName: aString
    name := aString.
    ^ self
!

name
    ^ name
! !

!Shape methodsFor: 'shape properties'!
getType
    ^ self class type
!

getArea
    self subclassResponsibility
!

getVolume
    self subclassResponsibility
!

getInfo
    self subclassResponsibility
! !

!Shape methodsFor: 'utility'!
safeNumberFrom: aString ifErrorReturn: defaultValue
    ^ [aString asFloat] 
        on: Error 
        do: [ :ex | Transcript show: 'Error: Invalid numeric value: ', aString; cr.
            ^ defaultValue
        ]
!

compareNumeric: lhsString op: opString rhs: rhsString
    |lhs rhs epsilon|
    epsilon := 1e-6.
    
    lhs := self safeNumberFrom: lhsString ifErrorReturn: 0.
    rhs := self safeNumberFrom: rhsString ifErrorReturn: 0.

    (opString = '==') ifTrue: [^ (lhs - rhs) abs < epsilon].
    (opString = '!=') ifTrue: [^ (lhs - rhs) abs >= epsilon].
    (opString = '>') ifTrue: [^ lhs > rhs].
    (opString = '<') ifTrue: [^ lhs < rhs].
    (opString = '>=') ifTrue: [^ lhs > rhs or: [(lhs - rhs) abs < epsilon]].
    (opString = '<=') ifTrue: [^ lhs < rhs or: [(lhs - rhs) abs < epsilon]].
    Transcript show: 'Error: ', opString, ' is not a valid operator for comparing numeric values.'; cr.
    ^ false
!

compareString: lhs op: opString rhs: rhs
    (opString = '==') ifTrue: [^ lhs = rhs].
    (opString = '!=') ifTrue: [^ (lhs = rhs) not].
    (opString = '>') ifTrue: [^ lhs > rhs].
    (opString = '<') ifTrue: [^ lhs < rhs].
    (opString = '>=') ifTrue: [^ lhs >= rhs].
    (opString = '<=') ifTrue: [^ lhs <= rhs].
    Transcript show: 'Error: ', opString, ' is not a valid operator for comparing strings.'; cr.
    ^ false
!

formatToTwoDecimalPlaces: aNumber
    | number str dotIndex |
    
    "Continue with normal formatting"
    [
        number := (aNumber asFloat * 100) rounded / 100.0.
        str := number printString.
        dotIndex := str indexOf: $. ifAbsent: [str size + 1].
        
        "If no decimal point, add .00"
        dotIndex > str size ifTrue: [^ str, '.00'].
        
        "If decimal point is at the end, add 00"
        dotIndex = str size ifTrue: [^ str, '00'].
        
        "If only one digit after decimal, add 0"
        dotIndex + 1 = str size ifTrue: [^ str, '0'].
        
        "If more than two digits after decimal, truncate"
        dotIndex + 2 < str size ifTrue: [
            ^ str copyFrom: 1 to: dotIndex + 2].
        
        "Otherwise return as is (already has exactly 2 decimal places)"
        ^ str
    ] on: Error do: [:ex |
        Transcript show: 'Error during number formatting: ', ex description; cr.
        ^ 'BAD'  "Return safe default if any error occurs"
    ]
! !

!Shape methodsFor: 'testing'!
test: conditions
    "conditions should be an array of strings in groups of three structured like ['name', 'op', 'value']"
    |i conditionName op value|
    "Check if conditions is a valid array"
    (conditions isEmpty or: [(conditions size \\ 3 = 0) not])
        ifTrue: [^true]. "For some reason I am supposed to return true if conditions are invalid"
    
    "Iterate through the conditions"
    i := 1.
    [i <= conditions size] whileTrue: [
        conditionName := conditions at: i.
        op := conditions at: (i + 1).
        value := conditions at: (i + 2).

        "Do lexicographic comparison to input value"
        conditionName = 'type' ifTrue: [
            (self compareString: self getType op: op rhs: value) ifFalse: [^ false]].
        
        "Do numeric comparison for area"
        conditionName = 'area' ifTrue: [
            (self compareNumeric: self getArea op: op rhs: value) ifFalse: [^ false]].

        "Do numeric comparison for volume"
        conditionName = 'volume' ifTrue: [
            (self compareNumeric: self getVolume op: op rhs: value) ifFalse: [^ false]].

        "If the conditionName is not recognized, signal an error"
        ((conditionName = 'type') not and: [(conditionName = 'area') not and: [(conditionName = 'volume') not]])
            ifTrue: [
                Transcript show: conditionName, ': invalid column.'; cr.
                ^ false].
        i := i + 3.
    ].
    ^ true
! !