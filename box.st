"
Box class definition
This class inherits from Shape and represents a box.
It provides methods to set and get the dimensions of the box,
and to calculate its area and volume.
It also includes a method to return information about the box.
"
Shape subclass: #Box
    instanceVariableNames: 'length width height'
    classVariableNames: ''
    package: 'ShapePackage'

"Class Constructor for Box"
Box class>>name: aString, length: aLength, width: aWidth, height: aHeight
    ^ self new initializeShape: aString, length: aLength, width: aWidth, height: aHeight

"Initializer for Box"
Box>>initializeShape: aString, length: aLength, width: aWidth, height: aHeight
    setName: aString.
    length := length.
    width := width.
    height := height.
    ^ self

"Setters and Getters for Box dimensions"
Box>>setLength: aLength
    length := aLength.
    ^ self

Box>>length
    ^ length

Box>>setWidth: aWidth
    width := aWidth.
    ^ self

Box>>width
    ^ width

Box>>setHeight: aHeight
    height := aHeight.
    ^ self

Box>>height
    ^ height

"Defines the type of the box class for the getType method in the superclass"
Box class>>type
    ^ 'box'

"Calculates the surface area of the box"
Box>>getArea
    ^ 2 * (length * width + length * height + width * height)

"Calculates the volume of the box"
Box>>getVolume
    ^ length * width * height

"Returns a string containing information for the box class"
Box>>getInfo
    | stream |
    stream := String new writeStream.
    stream
        nextPutAll: 'Box: ', self name, ' Length=';
        format: '%.2f' with: self length;
        nextPutAll: ', Width=';
        format: '%.2f' with: self width;
        nextPutAll: ', Height=';
        format: '%.2f' with: self height;
        nextPutAll: '   Surface Area=';
        format: '%.2f' with: self getArea;
        nextPutAll: ', Volume=';
        format: '%.2f' with: self getVolume.
    ^ stream contents

