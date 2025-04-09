"Shape class definition
This class inherits from the Shape class and represents a sphere.
It provides methods to set and get the radius of the sphere,
and to calculate its surface area and volume.
It also includes a method to return information about the sphere."

Shape subclass: #Sphere
    instanceVariableNames: 'radius'
    classVariableNames: ''
    poolDictionaries: ''.

!Sphere class methodsFor: 'instance creation'!
name: aString radius: aRadius
    ^ self new initializeShape: aString radius: aRadius
! !

!Sphere methodsFor: 'initialization'!
initializeShape: aString radius: aRadius
    self setName: aString.
    radius := aRadius.
    ^ self
! !

!Sphere methodsFor: 'accessing'!
setRadius: aRadius
    radius := aRadius.
    ^ self
!

radius
    ^ radius
! !

!Sphere class methodsFor: 'type definition'!
type
    ^ 'sphere'
! !

!Sphere methodsFor: 'shape properties'!
getArea
    ^ 4 * Float pi * radius squared
!

getVolume
    ^ (4.0 / 3.0) * Float pi * (radius * radius * radius)
! !

!Sphere methodsFor: 'printing'!
getInfo
    | formatRadius formatArea formatVolume line1 line2 |
    formatRadius := self formatToTwoDecimalPlaces: radius.
    formatArea := self formatToTwoDecimalPlaces: self getArea.
    formatVolume := self formatToTwoDecimalPlaces: self getVolume.
    line1 := 'Sphere: ', self name, ' Radius=', formatRadius.
    line2 := '   Surface Area=', formatArea, ', Volume=', formatVolume.
    ^ line1, Character lf asString, line2
! !
