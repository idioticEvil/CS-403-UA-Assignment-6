"
Cylinder class definition
This class inherits from Shape and represents a cylinder.
It provides methods to set and get the radius and height of the cylinder,
and to calculate its area and volume.
It also includes a method to return information about the cylinder.
"

Shape subclass: #Cylinder
    instanceVariableNames: 'radius height'
    classVariableNames: ''
    poolDictionaries: ''.

!Cylinder class methodsFor: 'instance creation'!
name: aString radius: aRadius height: aHeight
    ^ self new initializeShape: aString radius: aRadius height: aHeight
! !

!Cylinder methodsFor: 'initialization'!
initializeShape: aString radius: aRadius height: aHeight
    self setName: aString.
    radius := aRadius.
    height := aHeight.
    ^ self
! !

!Cylinder methodsFor: 'accessing'!
setRadius: aRadius
    radius := aRadius.
    ^ self
!

radius
    ^ radius
!

setHeight: aHeight
    height := aHeight.
    ^ self
!

height
    ^ height
! !

!Cylinder class methodsFor: 'type'!
type
    ^ 'cylinder'
! !

!Cylinder methodsFor: 'shape properties'!
getArea
    ^ 2 * Float pi * radius * (radius + height)
!

getVolume
    ^ Float pi * radius squared * height
! !

!Cylinder methodsFor: 'printing'!
getInfo
    | formatRadius formatHeight formatArea formatVolume line1 line2 |
    formatRadius := self formatToTwoDecimalPlaces: radius.
    formatHeight := self formatToTwoDecimalPlaces: height.
    formatArea := self formatToTwoDecimalPlaces: self getArea.
    formatVolume := self formatToTwoDecimalPlaces: self getVolume.
    
    line1 := 'Cylinder: ', self name, ' Radius=', formatRadius, ' Height=', formatHeight.
    line2 := '   Surface Area=', formatArea, ', Volume=', formatVolume.
    
    ^ line1, Character lf asString, line2
! !