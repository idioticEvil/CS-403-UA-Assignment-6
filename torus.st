"
Torus class definition
This class inherits from Shape and represents a torus (donut shape).
It provides methods to set and get the major and minor radii of the torus,
and to calculate its surface area and volume.
It also includes a method to return information about the torus.
"
Shape subclass: #Torus
    instanceVariableNames: 'majorRadius minorRadius'
    classVariableNames: ''
    package: 'ShapePackage'

"Class Constructor for Torus"
Torus class>>name: aString majorRadius: aMajorRadius minorRadius: aMinorRadius
    ^ self new initializeShape: aString majorRadius: aMajorRadius minorRadius: aMinorRadius

"Initializer for Torus"
Torus>>initializeShape: aString majorRadius: aMajorRadius minorRadius: aMinorRadius
    self setName: aString.
    majorRadius := aMajorRadius.
    minorRadius := aMinorRadius.
    ^ self

"Setters and Getters for Torus dimensions"
Torus>>setMajorRadius: aMajorRadius
    majorRadius := aMajorRadius.
    ^ self

Torus>>majorRadius
    ^ majorRadius

Torus>>setMinorRadius: aMinorRadius
    minorRadius := aMinorRadius.
    ^ self

Torus>>minorRadius
    ^ minorRadius

"Defines the type of the torus class for the getType method in the superclass"
Torus class>>type
    ^ 'torus'

"Calculates the surface area of the torus"
Torus>>getArea
    ^ 4.0 * Float pi squared * majorRadius * minorRadius

"Calculates the volume of the torus"
Torus>>getVolume
    ^ 2.0 * Float pi squared * majorRadius * minorRadius squared

"Returns a string containing information for the torus class"
Torus>>getInfo
    | stream |
    stream := String new writeStream.
    stream
        nextPutAll: 'Torus: ', self name, ' Small Radius=';
        format: '%.2f' with: self minorRadius;
        nextPutAll: ', Big Radius=';
        format: '%.2f' with: self majorRadius;
        nextPutAll: '   Surface Area=';
        format: '%.2f' with: self getArea;
        nextPutAll: ', Volume=';
        format: '%.2f' with: self getVolume.
    ^ stream contents
