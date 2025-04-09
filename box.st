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
    poolDictionaries: ''.

!Box class methodsFor: 'instance creation'!
name: aString length: aLength width: aWidth height: aHeight
    ^self new initializeShape: aString length: aLength width: aWidth height: aHeight
! !

!Box methodsFor: 'initialization'!
initializeShape: aString length: aLength width: aWidth height: aHeight
    self setName: aString.
    length := aLength.
    width := aWidth.
    height := aHeight.
    
    ^self
! !

!Box methodsFor: 'accessing'!
setLength: aLength
    length := aLength.
    ^self
!

length
    ^length
!

setWidth: aWidth
    width := aWidth.
    ^self
!

width
    ^width
!

setHeight: aHeight
    height := aHeight.
    ^self
!

height
    ^height
! !

!Box class methodsFor: 'shape properties'!
type
    ^'box'
! !

!Box methodsFor: 'shape properties'!
getArea
    | lw lh wh |
    lw := length * width.
    lh := length * height.
    wh := width * height.
    ^2 * (lw + lh + wh)
!

getVolume
    ^length * width * height
!

!Box methodsFor: 'printing'!
getInfo
    | formatLength formatWidth formatHeight formatArea formatVolume line1 line2 |

    formatLength := self formatToTwoDecimalPlaces: length.
    formatWidth := self formatToTwoDecimalPlaces: width.
    formatHeight := self formatToTwoDecimalPlaces: height.
    formatArea := self formatToTwoDecimalPlaces: self getArea.
    formatVolume := self formatToTwoDecimalPlaces: self getVolume.

    line1 := 'Box: ', self name, ' Length=', formatLength, 
             ', Width=', formatWidth, ', Height=', formatHeight.
             
    line2 := '   Surface Area=', formatArea, ', Volume=', formatVolume.
    
    ^ line1, Character lf asString, line2
! !