"
Cylinder class definition
This class inherits from Shape and represents a cylinder.
It provides methods to set and get the radius and height of the cylinder,
and to calculate its area and volume.
It also includes a method to return information about the cylinder.
"
Shape subclass: #Cylinder
    instanceVariableNames: 'radius, height'
    classVariableNames: ''
    package: 'ShapePackage'

"Class Constructor for Cylinder"
Cylinder class>>aString, radius: aRadius, height: aHeight
    ^ self new initializeShape: aString, radius: aRadius, height: aHeight

"Initializer for Cylinder"
Cylinder>>initializeShape: aString, radius: aRadius, height: aHeight
    setName: aString.
    radius := aRadius.
    height := aHeight.
    ^ self

"Setters and Getters for Cylinder dimensions"
Cylinder>>setRadius: aRadius
    radius := aRadius.
    ^ self

Cylinder>>radius
    ^ radius

Cylinder>>setHeight: aHeight
    height := aHeight.
    ^ self

Cylinder>>height
    ^ height

"Defines the type of the cylinder class for the getType method in the superclass"
Cylinder class>>type
    ^ 'cylinder'

"Calculates the surface area of the cylinder"
Cylinder>>getArea
    ^ 2 * Float pi * radius * (radius + height)

"Calculates the volume of the cylinder"
Cylinder>>getVolume
    ^ Float pi * radius squared * height

"Returns a string containing information for the cylinder class"
Cylinder>>getInfo
    | stream |
    stream := String new writeStream.
    stream
        nextPutAll: 'Cylinder: ', self name, ' Radius=';
        format: '%.2f' with: self radius;
        nextPutAll: ' Height=';
        format: '%.2f' with: self height;
        nextPutAll: '   Surface Area=';
        format: '%.2f' with: self getArea;
        nextPutAll: ', Volume=';
        format: '%.2f' with: self getVolume.
    ^ stream contents