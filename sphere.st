"
Sphere class definition
This class inherits from the Shape class and represents a sphere.
It provides methods to set and get the radius of the sphere,
and to calculate its surface area and volume.
It also includes a method to return information about the sphere.
"
Shape subclass: #Sphere
    instanceVariableNames: 'radius'
    classVariableNames: ''
    package: 'ShapePackage'

"Class Constructor for Sphere"
Sphere class>>aString, radius: aRadius
    ^ self new initializeShape: aString, radius: aRadius

"Initializer for Sphere"
Sphere>>initializeShape: aString, radius: aRadius
    setName: aString.
    radius := radius.
    ^ self

"Setter and Getter for Sphere radius"
Sphere>>setRadius: aRadius
    radius := aRadius.
    ^ self

Sphere>>radius
    ^ radius

"Defines the type of the sphere class for the getType method in the superclass"
Sphere class>>type
    ^ 'sphere'

"Calculates the surface area of the sphere"
Sphere>>getArea
    ^ 4 * Float pi * radius squared

"Calculates the volume of the sphere"
Sphere>>getVolume
    ^ (4.0 / 3.0) * Float pi * radius cubed

"Returns a string containing information for the sphere class"
Sphere>>getInfo
    | stream |
    stream := String new writeStream.
    stream
        nextPutAll: 'Sphere: ', self name, ' Radius=';
        format: '%.2f' with: self radius;
        nextPutAll: '   Surface Area=';
        format: '%.2f' with: self getArea;
        nextPutAll: ', Volume=';
        format: '%.2f' with: self getVolume.
    ^ stream contents
