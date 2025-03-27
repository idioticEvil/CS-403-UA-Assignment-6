"
Shape class definition
This class serves as a base class for different shapes.
It provides methods to set and get the name of the shape,
and abstract methods for getting type, area, volume, and info.
Subclasses will implement these abstract methods.
"
Object subclass: #Shape
    instanceVariableNames: 'name'
    classVariableNames: ''
    package: 'ShapePackage'

"Initializizer / Constructor for Shape"
Shape class>>name: aString
    ^ self new setName: aString

"Instance method to set the name of the shape"
Shape>>setName: aString
    name := aString.
    ^ self

"Instance method to get the name of the shape"
Shape>>name
    ^ name

"Instance method to get the type of the shape
the type is defined in derived classes"
Shape>>getType
    ^ self class type.

"Abstract method to get the surface area of the shape"
Shape>>getArea
    self subclassResponsibility

"Abstract method to get the volume of the shape"
Shape>>getVolume
    self subclassResponsibility

"Abstract method to return information about the shape"
Shape>>getInfo
    self subclassResponsibility

"Helper instance method for safe numeric conversion"
Shape>>safeNumberFrom: aString ifErrorReturn: defaultValue
    ^ [aString asFloat] 
        on: Error 
        do: [ :ex | Transcript show: 'Error: Invalid numeric value: ', aString; cr.
            ^ defaultValue
        ].

"Helper instance method used for comparing numeric values in the inherited classes"
Shape>>compareNumeric: lhsString op: opString rhs: rhs
    |lhs rhs epsilon|
    epsilon := 1e-6.
    
    lhs := self safeNumberFrom: lhsString ifErrorReturn: 0.
    rhs := self safeNumberFrom: rhs ifErrorReturn: 0.

    (opString = '==') ifTrue: [^ (lhs - rhs) abs < epsilon].
    (opString = '!=') ifTrue: [^ (lhs - rhs) abs >= epsilon].
    (opString = '>') ifTrue: [^ lhs > rhs].
    (opString = '<') ifTrue: [^ lhs < rhs].
    (opString = '>=') ifTrue: [^ lhs > rhs or: [(lhs - rhs) abs < epsilon]].
    (opString = '<=') ifTrue: [^ lhs < rhs or: [(lhs - rhs) abs < epsilon]].
    Transcript show 'Error: ', opString, ' is not a valid operator for comparing numeric values.'; cr.
    ^ false

"Helper instance method for string comparison"
Shape>>compareString: lhs op: opString rhs: rhs
    (opString = '==') ifTrue: [^ lhs = rhs].
    (opString = '!=') ifTrue: [^ lhs = rhs not].
    (opString = '>') ifTrue: [^ lhs > rhs].
    (opString = '<') ifTrue: [^ lhs < rhs].
    (opString = '>=') ifTrue: [^ lhs >= rhs].
    (opString = '<=') ifTrue: [^ lhs <= rhs].
    Transcript show 'Error: ', opString, ' is not a valid operator for comparing strings.'; cr.
    ^ false

"Instance method for testing if a shape satisfies a list of given conditions"
Shape>>test: conditions
    "conditions should be an array of strings in groups of three structured like ['name', 'op', 'value']"
    |i conditionName op value numValue|
    "Check if conditions is a valid array"
    (conditions isEmpty or: [conditions size \\ 3 = 0 not])
        ifTrue: [^true] "For some reason I am supposed to return true if conditions are invalid"
    
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
        ((conditionName = 'type') not and: [conditionName = 'area' not and: [conditionName = 'volume' not]])
            ifTrue: [
                Transcript show: conditionName, ': invalid column.'; cr.
                ^ false].
        i := i + 3.
    ].
    ^ true.