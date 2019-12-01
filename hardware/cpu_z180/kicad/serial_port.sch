EESchema Schematic File Version 4
LIBS:z180-cache
LIBS:stebus-port-cache
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 3 3
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector:DB9_Male_MountingHoles J2
U 1 1 5D97763C
P 8200 2300
F 0 "J2" H 8380 2302 50  0000 L CNN
F 1 "DB9_Male_MountingHoles" H 8380 2211 50  0000 L CNN
F 2 "Connector_Dsub:DSUB-9_Male_Horizontal_P2.77x2.84mm_EdgePinOffset9.40mm" H 8200 2300 50  0001 C CNN
F 3 " ~" H 8200 2300 50  0001 C CNN
	1    8200 2300
	1    0    0    -1  
$EndComp
$Comp
L Interface_UART:MAX232 U9
U 1 1 5D978989
P 5300 2300
F 0 "U9" H 5300 3681 50  0000 C CNN
F 1 "MAX232" H 5300 3590 50  0000 C CNN
F 2 "Housings_DIP:DIP-16_W7.62mm" H 5350 1250 50  0001 L CNN
F 3 "http://www.ti.com/lit/ds/symlink/max232.pdf" H 5300 2400 50  0001 C CNN
	1    5300 2300
	1    0    0    -1  
$EndComp
$Comp
L Connector:DB9_Male_MountingHoles J3
U 1 1 5DC110BA
P 8250 5400
F 0 "J3" H 8430 5402 50  0000 L CNN
F 1 "DB9_Male_MountingHoles" H 8430 5311 50  0000 L CNN
F 2 "Connector_Dsub:DSUB-9_Male_Horizontal_P2.77x2.84mm_EdgePinOffset9.40mm" H 8250 5400 50  0001 C CNN
F 3 " ~" H 8250 5400 50  0001 C CNN
	1    8250 5400
	1    0    0    -1  
$EndComp
$Comp
L Interface_UART:MAX232 U10
U 1 1 5DC110C0
P 5350 5400
F 0 "U10" H 5350 6781 50  0000 C CNN
F 1 "MAX232" H 5350 6690 50  0000 C CNN
F 2 "Housings_DIP:DIP-16_W7.62mm" H 5400 4350 50  0001 L CNN
F 3 "http://www.ti.com/lit/ds/symlink/max232.pdf" H 5350 5500 50  0001 C CNN
	1    5350 5400
	1    0    0    -1  
$EndComp
$EndSCHEMATC
