EESchema Schematic File Version 4
LIBS:z180-cache
LIBS:stebus-port-cache
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 3
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
L 74xx:74HC245 U5
U 1 1 5D961DDD
P 1950 2000
F 0 "U5" H 1800 2750 50  0000 C CNN
F 1 "74HC245" H 2200 2700 50  0000 C CNN
F 2 "Housings_DIP:DIP-20_W7.62mm" H 1950 2000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 1950 2000 50  0001 C CNN
	1    1950 2000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC245 U6
U 1 1 5D962A52
P 4050 1950
F 0 "U6" H 4050 2931 50  0000 C CNN
F 1 "74HC245" H 4050 2840 50  0000 C CNN
F 2 "Housings_DIP:DIP-20_W7.62mm" H 4050 1950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 4050 1950 50  0001 C CNN
	1    4050 1950
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC245 U7
U 1 1 5D96543B
P 4100 4000
F 0 "U7" H 4100 4981 50  0000 C CNN
F 1 "74HC245" H 4100 4890 50  0000 C CNN
F 2 "Housings_DIP:DIP-20_W7.62mm" H 4100 4000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 4100 4000 50  0001 C CNN
	1    4100 4000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC245 U8
U 1 1 5D9664C6
P 4100 6050
F 0 "U8" H 4100 7031 50  0000 C CNN
F 1 "74HC245" H 4100 6940 50  0000 C CNN
F 2 "Housings_DIP:DIP-20_W7.62mm" H 4100 6050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 4100 6050 50  0001 C CNN
	1    4100 6050
	1    0    0    -1  
$EndComp
$Comp
L z180-rescue:DIN41612-a+c-mylib J1
U 1 1 5D96789F
P 9800 2700
AR Path="/5D96789F" Ref="J1"  Part="1" 
AR Path="/5D9CAFE3/5D96789F" Ref="J1"  Part="1" 
F 0 "J1" H 9850 4417 50  0000 C CNN
F 1 "DIN41612-a+c" H 9850 4326 50  0000 C CNN
F 2 "mylib:DIN41612_A+C_2x32_Horizontal" H 9800 2700 50  0001 C CNN
F 3 "~" H 9800 2700 50  0001 C CNN
	1    9800 2700
	1    0    0    -1  
$EndComp
Text Label 9350 1200 0    50   ~ 0
GND
Text Label 9350 1300 0    50   ~ 0
+5V
Text Label 9300 1400 0    50   ~ 0
BUS_D0
Text Label 9300 1500 0    50   ~ 0
BUS_D2
Text Label 9300 1600 0    50   ~ 0
BUS_D4
Text Label 9300 1700 0    50   ~ 0
BUS_D6
Text Label 9300 1800 0    50   ~ 0
BUS_A0
Text Label 9300 1900 0    50   ~ 0
BUS_A2
Text Label 9300 2000 0    50   ~ 0
BUS_A4
Text Label 9300 2100 0    50   ~ 0
BUS_A6
Text Label 9300 2200 0    50   ~ 0
BUS_A8
Text Label 9300 2300 0    50   ~ 0
BUS_A10
Text Label 9300 2400 0    50   ~ 0
BUS_A12
Text Label 9300 2500 0    50   ~ 0
BUS_A14
Text Label 9300 2600 0    50   ~ 0
BUS_A16
Text Label 9300 2700 0    50   ~ 0
BUS_A18
Text Label 9300 2800 0    50   ~ 0
CM0
Text Label 9300 2900 0    50   ~ 0
CM2
Text Label 9300 3000 0    50   ~ 0
~ADRSTB~
Text Label 9300 3100 0    50   ~ 0
~DATACK~
Text Label 9300 3200 0    50   ~ 0
~TRFERR~
Text Label 9300 3300 0    50   ~ 0
~ATNRQ0~
Text Label 9300 3400 0    50   ~ 0
~ATNRQ2~
Text Label 9300 3500 0    50   ~ 0
~ATNRQ4~
Text Label 9300 3600 0    50   ~ 0
~
Text Label 9300 3700 0    50   ~ 0
GND
Text Label 9300 3800 0    50   ~ 0
~BUSRQ0~
Text Label 9300 3900 0    50   ~ 0
~BUSAK0~
Text Label 9300 4000 0    50   ~ 0
SYSCLK
Text Label 9300 4100 0    50   ~ 0
-12V
Text Label 9300 4200 0    50   ~ 0
+5V
Text Label 9300 4300 0    50   ~ 0
GND
Text Label 10250 1200 0    50   ~ 0
GND
Text Label 10250 1300 0    50   ~ 0
+5V
Text Label 10100 1400 0    50   ~ 0
BUS_D1
Text Label 10100 1500 0    50   ~ 0
BUS_D3
Text Label 10100 1600 0    50   ~ 0
BUS_D5
Text Label 10100 1700 0    50   ~ 0
BUS_D7
Text Label 10250 1800 0    50   ~ 0
GND
Text Label 10250 1900 0    50   ~ 0
BUS_A1
Text Label 10250 2000 0    50   ~ 0
BUS_A3
Text Label 10250 2100 0    50   ~ 0
BUS_A5
Text Label 10250 2200 0    50   ~ 0
BUS_A7
Text Label 10250 2300 0    50   ~ 0
BUS_A9
Text Label 10250 2400 0    50   ~ 0
BUS_A11
Text Label 10250 2500 0    50   ~ 0
BUS_A13
Text Label 10250 2600 0    50   ~ 0
BUS_A15
Text Label 10250 2700 0    50   ~ 0
BUS_A17
Text Label 10250 2800 0    50   ~ 0
BUS_A19
Text Label 10250 2900 0    50   ~ 0
CM1
Text Label 10250 3000 0    50   ~ 0
GND
Text Label 10100 3100 0    50   ~ 0
~DATASTB~
Text Label 10250 3200 0    50   ~ 0
GND
Text Label 10100 3300 0    50   ~ 0
~SYSRST~
Text Label 10100 3400 0    50   ~ 0
~ATNRQ1~
Text Label 10100 3500 0    50   ~ 0
~ATNRQ3
Text Label 10100 3600 0    50   ~ 0
~ATNRQ5~
Text Label 10100 3700 0    50   ~ 0
~ATNRQ7~
Text Label 10100 3800 0    50   ~ 0
~BUSRQ1~
Text Label 10100 3900 0    50   ~ 0
~BUSAK1~
Text Label 10150 4000 0    50   ~ 0
VSTBY
Text Label 10200 4100 0    50   ~ 0
+12V
Text Label 10250 4200 0    50   ~ 0
+5V
Text Label 10250 4300 0    50   ~ 0
GND
Entry Wire Line
	9300 1200 9200 1100
Entry Wire Line
	9200 1200 9300 1300
Entry Wire Line
	9200 1300 9300 1400
Entry Wire Line
	9200 1400 9300 1500
Entry Wire Line
	9200 1500 9300 1600
Entry Wire Line
	9200 1600 9300 1700
Entry Wire Line
	9200 1700 9300 1800
Entry Wire Line
	9200 1800 9300 1900
Entry Wire Line
	9200 1900 9300 2000
Entry Wire Line
	9200 2000 9300 2100
Entry Wire Line
	9200 2100 9300 2200
Entry Wire Line
	9200 2200 9300 2300
Entry Wire Line
	9200 2300 9300 2400
Entry Wire Line
	9200 2400 9300 2500
Entry Wire Line
	9200 2500 9300 2600
Entry Wire Line
	9200 2600 9300 2700
Entry Wire Line
	9200 2700 9300 2800
Entry Wire Line
	9200 2800 9300 2900
Entry Wire Line
	9200 2900 9300 3000
Entry Wire Line
	9200 3000 9300 3100
Entry Wire Line
	9200 3100 9300 3200
Entry Wire Line
	9200 3200 9300 3300
Entry Wire Line
	9200 3300 9300 3400
Entry Wire Line
	9200 3400 9300 3500
Entry Wire Line
	9200 3500 9300 3600
Entry Wire Line
	9200 3600 9300 3700
Entry Wire Line
	9200 3700 9300 3800
Entry Wire Line
	9200 3800 9300 3900
Entry Wire Line
	9200 3900 9300 4000
Entry Wire Line
	9200 4000 9300 4100
Entry Wire Line
	9200 4100 9300 4200
Entry Wire Line
	9200 4200 9300 4300
Entry Wire Line
	10400 1200 10500 1300
Entry Wire Line
	10400 1300 10500 1400
Entry Wire Line
	10400 1400 10500 1500
Entry Wire Line
	10400 1500 10500 1600
Entry Wire Line
	10400 1600 10500 1700
Entry Wire Line
	10400 1700 10500 1800
Entry Wire Line
	10400 1800 10500 1900
Entry Wire Line
	10400 1900 10500 2000
Entry Wire Line
	10400 2000 10500 2100
Entry Wire Line
	10400 2100 10500 2200
Entry Wire Line
	10400 2200 10500 2300
Entry Wire Line
	10400 2300 10500 2400
Entry Wire Line
	10400 2400 10500 2500
Entry Wire Line
	10400 2500 10500 2600
Entry Wire Line
	10400 2600 10500 2700
Entry Wire Line
	10400 2700 10500 2800
Entry Wire Line
	10400 2800 10500 2900
Entry Wire Line
	10400 2900 10500 3000
Entry Wire Line
	10400 3000 10500 3100
Entry Wire Line
	10400 3100 10500 3200
Entry Wire Line
	10400 3200 10500 3300
Entry Wire Line
	10400 3300 10500 3400
Entry Wire Line
	10400 3400 10500 3500
Entry Wire Line
	10400 3500 10500 3600
Entry Wire Line
	10400 3600 10500 3700
Entry Wire Line
	10400 3700 10500 3800
Entry Wire Line
	10400 3800 10500 3900
Entry Wire Line
	10400 3900 10500 4000
Entry Wire Line
	10400 4000 10500 4100
Entry Wire Line
	10400 4100 10500 4200
Entry Wire Line
	10400 4200 10500 4300
Entry Wire Line
	10400 4300 10500 4400
Text Label 9300 3600 0    50   ~ 0
~ATNRQ6~
Wire Wire Line
	9300 4300 9600 4300
Wire Wire Line
	9300 4200 9600 4200
Wire Wire Line
	9300 4100 9600 4100
Wire Wire Line
	9300 4000 9600 4000
Wire Wire Line
	9300 3900 9600 3900
Wire Wire Line
	9300 3700 9600 3700
Wire Wire Line
	9300 3600 9600 3600
Wire Wire Line
	9300 3500 9600 3500
Wire Wire Line
	9300 3400 9600 3400
Wire Wire Line
	9300 3300 9600 3300
Wire Wire Line
	9300 3200 9600 3200
Wire Wire Line
	9300 3100 9600 3100
Wire Wire Line
	9300 3000 9600 3000
Wire Wire Line
	9300 2900 9600 2900
Wire Wire Line
	9300 2800 9600 2800
Wire Wire Line
	9300 2700 9600 2700
Wire Wire Line
	9300 2600 9600 2600
Wire Wire Line
	9300 2500 9600 2500
Wire Wire Line
	9300 2400 9600 2400
Wire Wire Line
	9300 2300 9600 2300
Wire Wire Line
	9300 1200 9600 1200
Wire Wire Line
	9300 1300 9600 1300
Wire Wire Line
	9300 1400 9600 1400
Wire Wire Line
	9300 1500 9600 1500
Wire Wire Line
	9300 1600 9600 1600
Wire Wire Line
	9300 1700 9600 1700
Wire Wire Line
	9300 1800 9600 1800
Wire Wire Line
	9300 1900 9600 1900
Wire Wire Line
	9300 2000 9600 2000
Wire Wire Line
	9300 2100 9600 2100
Wire Wire Line
	9300 2200 9600 2200
Wire Wire Line
	9300 3800 9600 3800
Wire Wire Line
	10100 1200 10400 1200
Wire Wire Line
	10100 1300 10400 1300
Wire Wire Line
	10100 1400 10400 1400
Wire Wire Line
	10100 1500 10400 1500
Wire Wire Line
	10100 1600 10400 1600
Wire Wire Line
	10100 1700 10400 1700
Wire Wire Line
	10100 1800 10400 1800
Wire Wire Line
	10100 1900 10400 1900
Wire Wire Line
	10100 2000 10400 2000
Wire Wire Line
	10100 2100 10400 2100
Wire Wire Line
	10100 2200 10400 2200
Wire Wire Line
	10100 2300 10400 2300
Wire Wire Line
	10100 2400 10400 2400
Wire Wire Line
	10100 2500 10400 2500
Wire Wire Line
	10100 2600 10400 2600
Wire Wire Line
	10100 2700 10400 2700
Wire Wire Line
	10100 2800 10400 2800
Wire Wire Line
	10100 2900 10400 2900
Wire Wire Line
	10100 3000 10400 3000
Wire Wire Line
	10100 3100 10400 3100
Wire Wire Line
	10100 3200 10400 3200
Wire Wire Line
	10100 3300 10400 3300
Wire Wire Line
	10100 3400 10400 3400
Wire Wire Line
	10100 3500 10400 3500
Wire Wire Line
	10100 3600 10400 3600
Wire Wire Line
	10100 3700 10400 3700
Wire Wire Line
	10100 3800 10400 3800
Wire Wire Line
	10100 3900 10400 3900
Wire Wire Line
	10100 4000 10400 4000
Wire Wire Line
	10100 4100 10400 4100
Wire Wire Line
	10100 4200 10400 4200
Wire Wire Line
	10100 4300 10400 4300
Wire Wire Line
	2450 1500 2700 1500
Text Label 2450 1500 0    50   ~ 0
BUS_D0
Wire Wire Line
	2450 1600 2700 1600
Wire Wire Line
	2450 1700 2700 1700
Wire Wire Line
	2700 1800 2450 1800
Wire Wire Line
	2700 1900 2450 1900
Wire Wire Line
	2700 2000 2450 2000
Wire Wire Line
	2700 2100 2450 2100
Wire Wire Line
	2700 2200 2450 2200
Text Label 2450 1600 0    50   ~ 0
BUS_D1
Text Label 2450 1700 0    50   ~ 0
BUS_D2
Text Label 2450 1800 0    50   ~ 0
BUS_D3
Text Label 2450 1900 0    50   ~ 0
BUS_D4
Text Label 2450 2000 0    50   ~ 0
BUS_D5
Text Label 2450 2100 0    50   ~ 0
BUS_D6
Text Label 2450 2200 0    50   ~ 0
BUS_D7
$Comp
L power:GND #PWR0111
U 1 1 5DC76A63
P 1950 2900
F 0 "#PWR0111" H 1950 2650 50  0001 C CNN
F 1 "GND" H 1955 2727 50  0000 C CNN
F 2 "" H 1950 2900 50  0001 C CNN
F 3 "" H 1950 2900 50  0001 C CNN
	1    1950 2900
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0112
U 1 1 5DC76F2E
P 1950 1100
F 0 "#PWR0112" H 1950 950 50  0001 C CNN
F 1 "+5V" H 1965 1273 50  0000 C CNN
F 2 "" H 1950 1100 50  0001 C CNN
F 3 "" H 1950 1100 50  0001 C CNN
	1    1950 1100
	1    0    0    -1  
$EndComp
Wire Wire Line
	1950 1100 1950 1200
Wire Wire Line
	1950 2800 1950 2900
Entry Wire Line
	1050 1400 1150 1500
Entry Wire Line
	1050 1500 1150 1600
Entry Wire Line
	1050 1600 1150 1700
Entry Wire Line
	1050 1700 1150 1800
Entry Wire Line
	1050 1800 1150 1900
Entry Wire Line
	1050 1900 1150 2000
Entry Wire Line
	1050 2000 1150 2100
Entry Wire Line
	1050 2100 1150 2200
Wire Wire Line
	1150 1500 1450 1500
Wire Wire Line
	1450 1600 1150 1600
Wire Wire Line
	1150 1700 1450 1700
Wire Wire Line
	1450 1800 1150 1800
Wire Wire Line
	1150 1900 1450 1900
Wire Wire Line
	1450 2000 1150 2000
Wire Wire Line
	1450 2100 1150 2100
Wire Wire Line
	1150 2200 1450 2200
Text Label 1250 1500 0    50   ~ 0
D0
Text Label 1250 1600 0    50   ~ 0
D1
Text Label 1250 1700 0    50   ~ 0
D2
Text Label 1250 1800 0    50   ~ 0
D3
Text Label 1250 1900 0    50   ~ 0
D4
Text Label 1250 2000 0    50   ~ 0
D5
Text Label 1250 2100 0    50   ~ 0
D6
Text Label 1250 2200 0    50   ~ 0
D7
Text Label 1050 1300 1    50   ~ 0
D[0..7]
$Comp
L Connector_Generic:Conn_02x05_Counter_Clockwise J4
U 1 1 5DCA9A20
P 8200 4000
F 0 "J4" H 8250 4417 50  0000 C CNN
F 1 "Conn_02x05_Counter_Clockwise" H 8250 4326 50  0000 C CNN
F 2 "Connectors_JAE:JAE_LY20-10P-2T_2x05x2.00mm_Straight" H 8200 4000 50  0001 C CNN
F 3 "~" H 8200 4000 50  0001 C CNN
	1    8200 4000
	1    0    0    -1  
$EndComp
Text GLabel 1050 1000 1    50   Input ~ 0
D[0..7]
Wire Wire Line
	3550 1450 3300 1450
Wire Wire Line
	3300 1550 3550 1550
Wire Wire Line
	3300 1650 3550 1650
Wire Wire Line
	3300 1750 3550 1750
Wire Wire Line
	3300 1850 3550 1850
Wire Wire Line
	3300 1950 3550 1950
Wire Wire Line
	3300 2050 3550 2050
Wire Wire Line
	3300 2150 3550 2150
Entry Wire Line
	3200 1350 3300 1450
Entry Wire Line
	3200 1450 3300 1550
Entry Wire Line
	3200 1550 3300 1650
Entry Wire Line
	3200 1650 3300 1750
Entry Wire Line
	3200 1750 3300 1850
Entry Wire Line
	3200 1850 3300 1950
Entry Wire Line
	3200 1950 3300 2050
Entry Wire Line
	3200 2050 3300 2150
Entry Wire Line
	3200 3400 3300 3500
Entry Wire Line
	3200 3500 3300 3600
Entry Wire Line
	3200 3600 3300 3700
Entry Wire Line
	3200 3700 3300 3800
Entry Wire Line
	3200 3800 3300 3900
Entry Wire Line
	3200 3900 3300 4000
Entry Wire Line
	3200 4000 3300 4100
Entry Wire Line
	3200 4100 3300 4200
Entry Wire Line
	3200 5450 3300 5550
Entry Wire Line
	3200 5550 3300 5650
Entry Wire Line
	3200 5650 3300 5750
Entry Wire Line
	3200 5750 3300 5850
Wire Wire Line
	3300 3500 3600 3500
Wire Wire Line
	3300 3600 3600 3600
Wire Wire Line
	3300 3700 3600 3700
Wire Wire Line
	3300 3800 3600 3800
Wire Wire Line
	3300 3900 3600 3900
Wire Wire Line
	3300 4000 3600 4000
Wire Wire Line
	3300 4100 3600 4100
Wire Wire Line
	3300 4200 3600 4200
Wire Wire Line
	3300 5550 3600 5550
Wire Wire Line
	3300 5650 3600 5650
Wire Wire Line
	3300 5750 3600 5750
Wire Wire Line
	3300 5850 3600 5850
Text Label 3400 1450 0    50   ~ 0
A0
Text Label 3400 1550 0    50   ~ 0
A1
Text Label 3400 1650 0    50   ~ 0
A2
Text Label 3400 1750 0    50   ~ 0
A3
Text Label 3400 1850 0    50   ~ 0
A4
Text Label 3400 1950 0    50   ~ 0
A5
Text Label 3400 2050 0    50   ~ 0
A6
Text Label 3400 2150 0    50   ~ 0
A7
Text Label 3400 3500 0    50   ~ 0
A8
Text Label 3400 3600 0    50   ~ 0
A9
Text Label 3400 3700 0    50   ~ 0
A10
Text Label 3400 3800 0    50   ~ 0
A11
Text Label 3400 3900 0    50   ~ 0
A12
Text Label 3400 4000 0    50   ~ 0
A13
Text Label 3400 4100 0    50   ~ 0
A14
Text Label 3400 4200 0    50   ~ 0
A15
Text Label 3400 5550 0    50   ~ 0
A16
Text Label 3400 5650 0    50   ~ 0
A17
Text Label 3400 5750 0    50   ~ 0
A18
Text Label 3400 5850 0    50   ~ 0
A19
Text GLabel 3200 1000 1    50   Input ~ 0
A[0..19]
Text Label 3200 2950 1    50   ~ 0
A[0..19]
Wire Wire Line
	4850 1450 4550 1450
Wire Wire Line
	4850 1550 4550 1550
Wire Wire Line
	4850 1650 4550 1650
Wire Wire Line
	4850 1750 4550 1750
Wire Wire Line
	4850 1850 4550 1850
Wire Wire Line
	4850 1950 4550 1950
Wire Wire Line
	4850 2050 4550 2050
Wire Wire Line
	4850 2150 4550 2150
Wire Wire Line
	4900 3500 4600 3500
Wire Wire Line
	4900 3600 4600 3600
Wire Wire Line
	4900 3700 4600 3700
Wire Wire Line
	4900 3800 4600 3800
Wire Wire Line
	4900 3900 4600 3900
Wire Wire Line
	4900 4000 4600 4000
Wire Wire Line
	4900 4100 4600 4100
Wire Wire Line
	4900 4200 4600 4200
Wire Wire Line
	4950 5550 4600 5550
Wire Wire Line
	4950 5650 4600 5650
Wire Wire Line
	4950 5750 4600 5750
Wire Wire Line
	4950 5850 4600 5850
Wire Wire Line
	4950 5950 4600 5950
Wire Wire Line
	4950 6050 4600 6050
Wire Wire Line
	4950 6150 4600 6150
Wire Wire Line
	4950 6250 4600 6250
Text Label 4550 1450 0    50   ~ 0
BUS_A0
Text Label 4550 1550 0    50   ~ 0
BUS_A1
Text Label 4550 1650 0    50   ~ 0
BUS_A2
Text Label 4550 1750 0    50   ~ 0
BUS_A3
Text Label 4550 1850 0    50   ~ 0
BUS_A4
Text Label 4550 1950 0    50   ~ 0
BUS_A5
Text Label 4550 2050 0    50   ~ 0
BUS_A6
Text Label 4550 2150 0    50   ~ 0
BUS_A7
Text Label 4600 3500 0    50   ~ 0
BUS_A8
Text Label 4600 3600 0    50   ~ 0
BUS_A9
Text Label 4600 3700 0    50   ~ 0
BUS_A10
Text Label 4600 3800 0    50   ~ 0
BUS_A11
Text Label 4600 3900 0    50   ~ 0
BUS_A12
Text Label 4600 4000 0    50   ~ 0
BUS_A13
Text Label 4600 4100 0    50   ~ 0
BUS_A14
Text Label 4600 4200 0    50   ~ 0
BUS_A15
Text Label 4600 5550 0    50   ~ 0
BUS_A16
Text Label 4600 5650 0    50   ~ 0
BUS_A17
Text Label 4600 5750 0    50   ~ 0
BUS_A18
Text Label 4600 5850 0    50   ~ 0
BUS_A19
Wire Wire Line
	3550 2450 3050 2450
Wire Wire Line
	3050 2450 3050 4500
Wire Wire Line
	3050 4500 3600 4500
Wire Wire Line
	3050 4500 3050 6550
Wire Wire Line
	3050 6550 3600 6550
Connection ~ 3050 4500
Wire Wire Line
	1450 2500 1300 2500
Wire Wire Line
	1300 2500 1300 4500
Wire Wire Line
	1300 4500 3050 4500
Wire Bus Line
	1050 1000 1050 2250
Wire Bus Line
	3200 1000 3200 5750
$EndSCHEMATC
