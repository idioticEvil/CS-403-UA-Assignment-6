"Shape class definition
This class inherits from Shape and represents a torus (donut shape).
It provides methods to set and get the major and minor radii of the torus,
and to calculate its surface area and volume.
It also includes a method to return information about the torus."

Shape subclass: #Torus
    instanceVariableNames: 'majorRadius minorRadius'
    classVariableNames: ''
    poolDictionaries: ''.

!Torus class methodsFor: 'instance creation'!
name: aString minorRadius: aMinorRadius majorRadius: aMajorRadius
    ^ self new initializeShape: aString minorRadius: aMinorRadius majorRadius: aMajorRadius
! !

!Torus methodsFor: 'initialization'!
initializeShape: aString minorRadius: aMinorRadius majorRadius: aMajorRadius 
    self setName: aString.
    minorRadius := aMinorRadius.
    majorRadius := aMajorRadius.

    ^ self
! !

!Torus methodsFor: 'accessing'!
setMajorRadius: aMajorRadius
    majorRadius := aMajorRadius.
    ^ self
!

majorRadius
    ^ majorRadius
!

setMinorRadius: aMinorRadius
    minorRadius := aMinorRadius.
    ^ self
!

minorRadius
    ^ minorRadius
! !

!Torus class methodsFor: 'type'!
type
    ^ 'torus'
! !


!Torus methodsFor: 'shape properties'!
getArea
    ^ 4 * (Float pi * Float pi) * majorRadius * minorRadius
!

"Volume of a torus: 2 * pi^2 * R * r^2"
getVolume
    ^ 2 * Float pi squared * majorRadius * (minorRadius squared)
! !

!Torus methodsFor: 'printing'!
getInfo
    | formatMinorRadius formatMajorRadius formatArea formatVolume line1 line2 |
    
    formatMinorRadius := self formatToTwoDecimalPlaces: minorRadius.
    formatMajorRadius := self formatToTwoDecimalPlaces: majorRadius.
    formatArea := self formatToTwoDecimalPlaces: self getArea.
    formatVolume := self formatToTwoDecimalPlaces: self getVolume.

    line1 := 'Torus: ', self name, ' Small Radius=', formatMinorRadius, ', Big Radius=', formatMajorRadius.
    line2 := '   Surface Area=', formatArea, ', Volume=', formatVolume.
    ^ line1, Character lf asString, line2
! !
