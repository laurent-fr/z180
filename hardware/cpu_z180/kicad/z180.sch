EESchema Schematic File Version 4
LIBS:z180-cache
LIBS:stebus-port-cache
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 3
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
L z180-rescue:Z8S180CPU-mylib U1
U 1 1 5D93C9FF
P 4950 2650
F 0 "U1" H 4450 4100 50  0000 C CNN
F 1 "Z8S180CPU" H 5250 4100 50  0000 C CNN
F 2 "Package_LCC:PLCC-68_THT-Socket" H 4950 3050 50  0001 C CNN
F 3 "www.zilog.com/manage_directlink.php?filepath=docs/z80/um0080" H 4950 3050 50  0001 C CNN
	1    4950 2650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 5D947F70
P 4750 6100
F 0 "#PWR0101" H 4750 5850 50  0001 C CNN
F 1 "GND" H 4755 5927 50  0000 C CNN
F 2 "" H 4750 6100 50  0001 C CNN
F 3 "" H 4750 6100 50  0001 C CNN
	1    4750 6100
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 5900 4750 6000
Wire Wire Line
	4750 6000 4850 6000
Wire Wire Line
	4850 6000 4850 5900
Wire Wire Line
	4850 6000 4950 6000
Wire Wire Line
	4950 6000 4950 5900
Connection ~ 4850 6000
Wire Wire Line
	5050 6000 5050 5900
Wire Wire Line
	4950 6000 5050 6000
Connection ~ 4950 6000
Wire Wire Line
	4750 6000 4750 6100
Connection ~ 4750 6000
$Comp
L power:+5V #PWR0102
U 1 1 5D9490FF
P 4950 950
F 0 "#PWR0102" H 4950 800 50  0001 C CNN
F 1 "+5V" H 4965 1123 50  0000 C CNN
F 2 "" H 4950 950 50  0001 C CNN
F 3 "" H 4950 950 50  0001 C CNN
	1    4950 950 
	1    0    0    -1  
$EndComp
Wire Wire Line
	4950 950  4950 1150
$Comp
L Memory_RAM:AS6C4008-55PCN U2
U 1 1 5D949A9D
P 7300 2350
F 0 "U2" H 6950 3450 50  0000 C CNN
F 1 "AS6C4008-55PCN" H 7700 3450 50  0000 C CNN
F 2 "Package_DIP:DIP-32_W15.24mm" H 7300 2450 50  0001 C CNN
F 3 "https://www.alliancememory.com/wp-content/uploads/pdf/AS6C4008.pdf" H 7300 2450 50  0001 C CNN
	1    7300 2350
	1    0    0    -1  
$EndComp
$Comp
L Memory_EPROM:27C010 U3
U 1 1 5D94D3EE
P 9300 2450
F 0 "U3" H 9100 3650 50  0000 C CNN
F 1 "27C010" H 9500 3650 50  0000 C CNN
F 2 "Housings_DIP:DIP-32_W15.24mm" H 9300 2450 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0321.pdf" H 9300 2450 50  0001 C CNN
	1    9300 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 1450 5800 1450
Wire Wire Line
	5650 1550 5800 1550
Wire Wire Line
	5650 1650 5800 1650
Wire Wire Line
	5650 1750 5800 1750
Text Label 5700 1450 0    50   ~ 0
A0
Text Label 5700 1550 0    50   ~ 0
A1
Text Label 5700 1650 0    50   ~ 0
A2
Text Label 5700 1750 0    50   ~ 0
A3
Wire Wire Line
	5650 1850 5800 1850
Wire Wire Line
	5650 1950 5800 1950
Wire Wire Line
	5650 2050 5800 2050
Wire Wire Line
	5650 2150 5800 2150
Wire Wire Line
	5650 2250 5800 2250
Wire Wire Line
	5650 2350 5800 2350
Wire Wire Line
	5650 2450 5800 2450
Wire Wire Line
	5650 2550 5800 2550
Wire Wire Line
	5650 2650 5800 2650
Wire Wire Line
	5650 2750 5800 2750
Wire Wire Line
	5650 2850 5800 2850
Wire Wire Line
	5650 2950 5800 2950
Wire Wire Line
	5650 3050 5800 3050
Wire Wire Line
	5650 3150 5800 3150
Wire Wire Line
	5650 3250 5800 3250
Wire Wire Line
	5650 3350 5800 3350
Wire Wire Line
	6800 1450 6650 1450
Wire Wire Line
	6800 1550 6650 1550
Wire Wire Line
	6800 1650 6650 1650
Wire Wire Line
	6800 1750 6650 1750
Wire Wire Line
	6800 1850 6650 1850
Wire Wire Line
	6800 1950 6650 1950
Wire Wire Line
	6800 2050 6650 2050
Wire Wire Line
	6800 2150 6650 2150
Wire Wire Line
	6800 2250 6650 2250
Wire Wire Line
	6800 2350 6650 2350
Wire Wire Line
	6800 2450 6650 2450
Wire Wire Line
	6800 2550 6650 2550
Wire Wire Line
	6800 2650 6650 2650
Wire Wire Line
	6800 2750 6650 2750
Wire Wire Line
	6800 2850 6650 2850
Wire Wire Line
	6800 2950 6650 2950
Wire Wire Line
	6800 3050 6650 3050
Wire Wire Line
	6800 3150 6650 3150
Wire Wire Line
	6800 3250 6650 3250
Wire Wire Line
	7800 1450 7950 1450
Wire Wire Line
	7950 1550 7800 1550
Wire Wire Line
	7800 1650 7950 1650
Wire Wire Line
	7800 1750 7950 1750
Wire Wire Line
	7800 1850 7950 1850
Wire Wire Line
	7800 1950 7950 1950
Wire Wire Line
	7800 2050 7950 2050
Wire Wire Line
	7800 2150 7950 2150
Wire Wire Line
	8900 1450 8750 1450
Wire Wire Line
	8900 1550 8750 1550
Wire Wire Line
	8900 1650 8750 1650
Wire Wire Line
	8900 1750 8750 1750
Wire Wire Line
	8900 1850 8750 1850
Wire Wire Line
	8900 1950 8750 1950
Wire Wire Line
	8900 2050 8750 2050
Wire Wire Line
	8900 2150 8750 2150
Wire Wire Line
	8900 2250 8750 2250
Wire Wire Line
	8900 2350 8750 2350
Wire Wire Line
	8900 2450 8750 2450
Wire Wire Line
	8900 2550 8750 2550
Wire Wire Line
	8900 2650 8750 2650
Wire Wire Line
	8900 2750 8750 2750
Wire Wire Line
	8900 2850 8750 2850
Wire Wire Line
	8900 2950 8750 2950
Wire Wire Line
	8900 3050 8750 3050
Wire Wire Line
	9700 1450 9850 1450
Wire Wire Line
	9850 1550 9700 1550
Wire Wire Line
	9850 1650 9700 1650
Wire Wire Line
	9850 1750 9700 1750
Wire Wire Line
	9850 1850 9700 1850
Wire Wire Line
	9850 1950 9700 1950
Wire Wire Line
	9850 2050 9700 2050
Wire Wire Line
	9850 2150 9700 2150
Text Label 9750 1450 0    50   ~ 0
D0
Text Label 9750 1550 0    50   ~ 0
D1
Text Label 9750 1650 0    50   ~ 0
D2
Text Label 9750 1750 0    50   ~ 0
D3
Text Label 9750 1850 0    50   ~ 0
D4
Text Label 9750 1950 0    50   ~ 0
D5
Text Label 9750 2050 0    50   ~ 0
D6
Text Label 9750 2150 0    50   ~ 0
D7
Text Label 5700 1850 0    50   ~ 0
A4
Text Label 5700 1950 0    50   ~ 0
A5
Text Label 5700 2050 0    50   ~ 0
A6
Text Label 5700 2150 0    50   ~ 0
A7
Text Label 5700 2250 0    50   ~ 0
A8
Text Label 5700 2350 0    50   ~ 0
A9
Text Label 5700 2450 0    50   ~ 0
A10
Text Label 5700 2550 0    50   ~ 0
A11
Text Label 5700 2650 0    50   ~ 0
A12
Text Label 5700 2750 0    50   ~ 0
A13
Text Label 5700 2850 0    50   ~ 0
A14
Text Label 5700 2950 0    50   ~ 0
A15
Text Label 5700 3050 0    50   ~ 0
A16
Text Label 5700 3150 0    50   ~ 0
A17
Text Label 5700 3250 0    50   ~ 0
A18
Text Label 5700 3350 0    50   ~ 0
A19
Text Label 5700 3650 0    50   ~ 0
D0
Text Label 5700 3750 0    50   ~ 0
D1
Text Label 5700 3850 0    50   ~ 0
D2
Text Label 5700 3950 0    50   ~ 0
D3
Text Label 5700 4050 0    50   ~ 0
D4
Text Label 5700 4150 0    50   ~ 0
D5
Text Label 5700 4250 0    50   ~ 0
D6
Text Label 5700 4350 0    50   ~ 0
D7
Text Label 6650 1450 0    50   ~ 0
A0
Text Label 6650 1550 0    50   ~ 0
A1
Text Label 6650 1650 0    50   ~ 0
A2
Text Label 6650 1750 0    50   ~ 0
A3
Text Label 6650 1850 0    50   ~ 0
A4
Text Label 6650 1950 0    50   ~ 0
A5
Text Label 6650 2050 0    50   ~ 0
A6
Text Label 6650 2150 0    50   ~ 0
A7
Text Label 6650 2250 0    50   ~ 0
A8
Text Label 6650 2350 0    50   ~ 0
A9
Text Label 6650 2450 0    50   ~ 0
A10
Text Label 6650 2550 0    50   ~ 0
A11
Text Label 6650 2650 0    50   ~ 0
A12
Text Label 6650 2750 0    50   ~ 0
A13
Text Label 6650 2850 0    50   ~ 0
A14
Text Label 6650 2950 0    50   ~ 0
A15
Text Label 6650 3050 0    50   ~ 0
A16
Text Label 6650 3150 0    50   ~ 0
A17
Text Label 6650 3250 0    50   ~ 0
A18
Text Label 7850 1450 0    50   ~ 0
D0
Text Label 7850 1550 0    50   ~ 0
D1
Text Label 7850 1650 0    50   ~ 0
D2
Text Label 7850 1750 0    50   ~ 0
D3
Text Label 7850 1850 0    50   ~ 0
D4
Text Label 7850 1950 0    50   ~ 0
D5
Text Label 7850 2050 0    50   ~ 0
D6
Text Label 7850 2150 0    50   ~ 0
D7
Text Label 8750 1450 0    50   ~ 0
A0
Text Label 8750 1550 0    50   ~ 0
A1
Text Label 8750 1650 0    50   ~ 0
A2
Text Label 8750 1750 0    50   ~ 0
A3
Text Label 8750 1850 0    50   ~ 0
A4
Text Label 8750 1950 0    50   ~ 0
A5
Text Label 8750 2050 0    50   ~ 0
A6
Text Label 8750 2150 0    50   ~ 0
A7
Text Label 8750 2250 0    50   ~ 0
A8
Text Label 8750 2350 0    50   ~ 0
A9
Text Label 8750 2450 0    50   ~ 0
A10
Text Label 8750 2550 0    50   ~ 0
A11
Text Label 8750 2650 0    50   ~ 0
A12
Text Label 8750 2750 0    50   ~ 0
A13
Text Label 8750 2850 0    50   ~ 0
A14
Text Label 8750 2950 0    50   ~ 0
A15
Text Label 8750 3050 0    50   ~ 0
A16
$Comp
L power:+5V #PWR0103
U 1 1 5D9B1F61
P 7300 950
F 0 "#PWR0103" H 7300 800 50  0001 C CNN
F 1 "+5V" H 7315 1123 50  0000 C CNN
F 2 "" H 7300 950 50  0001 C CNN
F 3 "" H 7300 950 50  0001 C CNN
	1    7300 950 
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0104
U 1 1 5D9B271B
P 9300 1000
F 0 "#PWR0104" H 9300 850 50  0001 C CNN
F 1 "+5V" H 9315 1173 50  0000 C CNN
F 2 "" H 9300 1000 50  0001 C CNN
F 3 "" H 9300 1000 50  0001 C CNN
	1    9300 1000
	1    0    0    -1  
$EndComp
Wire Wire Line
	7300 950  7300 1250
Wire Wire Line
	9300 1000 9300 1250
$Comp
L power:GND #PWR0105
U 1 1 5D9B861F
P 7300 3850
F 0 "#PWR0105" H 7300 3600 50  0001 C CNN
F 1 "GND" H 7305 3677 50  0000 C CNN
F 2 "" H 7300 3850 50  0001 C CNN
F 3 "" H 7300 3850 50  0001 C CNN
	1    7300 3850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0106
U 1 1 5D9B8BC2
P 9300 3850
F 0 "#PWR0106" H 9300 3600 50  0001 C CNN
F 1 "GND" H 9305 3677 50  0000 C CNN
F 2 "" H 9300 3850 50  0001 C CNN
F 3 "" H 9300 3850 50  0001 C CNN
	1    9300 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	9300 3750 9300 3850
Wire Wire Line
	7300 3450 7300 3850
Entry Wire Line
	5800 1450 5900 1550
Entry Wire Line
	5800 1550 5900 1650
Entry Wire Line
	5800 1650 5900 1750
Entry Wire Line
	5800 1750 5900 1850
Entry Wire Line
	5800 1850 5900 1950
Entry Wire Line
	5800 1950 5900 2050
Entry Wire Line
	5800 2050 5900 2150
Entry Wire Line
	5800 2150 5900 2250
Entry Wire Line
	5800 2250 5900 2350
Entry Wire Line
	5800 2350 5900 2450
Entry Wire Line
	5800 2450 5900 2550
Entry Wire Line
	5800 2550 5900 2650
Entry Wire Line
	5800 2650 5900 2750
Entry Wire Line
	5800 2750 5900 2850
Entry Wire Line
	5800 2850 5900 2950
Entry Wire Line
	5800 2950 5900 3050
Entry Wire Line
	5800 3050 5900 3150
Entry Wire Line
	5800 3150 5900 3250
Entry Wire Line
	5800 3250 5900 3350
Entry Wire Line
	5800 3350 5900 3450
Entry Wire Line
	5900 3650 6000 3750
Entry Wire Line
	5900 3750 6000 3850
Entry Wire Line
	5900 3850 6000 3950
Entry Wire Line
	5900 3950 6000 4050
Entry Wire Line
	5900 4050 6000 4150
Entry Wire Line
	5900 4150 6000 4250
Entry Wire Line
	5900 4250 6000 4350
Entry Wire Line
	5900 4350 6000 4450
Wire Wire Line
	5650 3650 5900 3650
Wire Wire Line
	5650 3750 5900 3750
Wire Wire Line
	5650 3850 5900 3850
Wire Wire Line
	5650 3950 5900 3950
Wire Wire Line
	5650 4050 5900 4050
Wire Wire Line
	5650 4150 5900 4150
Wire Wire Line
	5650 4250 5900 4250
Wire Wire Line
	5650 4350 5900 4350
Entry Wire Line
	6550 1650 6650 1750
Entry Wire Line
	6550 1350 6650 1450
Entry Wire Line
	6550 1450 6650 1550
Entry Wire Line
	6550 1550 6650 1650
Entry Wire Line
	6550 1750 6650 1850
Entry Wire Line
	6550 1850 6650 1950
Entry Wire Line
	6550 1950 6650 2050
Entry Wire Line
	6550 2050 6650 2150
Entry Wire Line
	6550 2150 6650 2250
Entry Wire Line
	6550 2250 6650 2350
Entry Wire Line
	6550 2350 6650 2450
Entry Wire Line
	6550 2450 6650 2550
Entry Wire Line
	6550 2550 6650 2650
Entry Wire Line
	6550 2650 6650 2750
Entry Wire Line
	6550 2750 6650 2850
Entry Wire Line
	6550 2850 6650 2950
Entry Wire Line
	6550 2950 6650 3050
Entry Wire Line
	6550 3050 6650 3150
Entry Wire Line
	6550 3150 6650 3250
Entry Wire Line
	7950 1450 8050 1550
Entry Wire Line
	7950 1550 8050 1650
Entry Wire Line
	7950 1650 8050 1750
Entry Wire Line
	7950 1750 8050 1850
Entry Wire Line
	7950 1850 8050 1950
Entry Wire Line
	7950 1950 8050 2050
Entry Wire Line
	7950 2050 8050 2150
Entry Wire Line
	7950 2150 8050 2250
Entry Wire Line
	8650 1350 8750 1450
Entry Wire Line
	8650 1450 8750 1550
Entry Wire Line
	8650 1550 8750 1650
Entry Wire Line
	8650 1650 8750 1750
Entry Wire Line
	8650 1750 8750 1850
Entry Wire Line
	8650 1850 8750 1950
Entry Wire Line
	8650 1950 8750 2050
Entry Wire Line
	8650 2050 8750 2150
Entry Wire Line
	8650 2150 8750 2250
Entry Wire Line
	8650 2250 8750 2350
Entry Wire Line
	8650 2350 8750 2450
Entry Wire Line
	8650 2450 8750 2550
Entry Wire Line
	8650 2550 8750 2650
Entry Wire Line
	8650 2650 8750 2750
Entry Wire Line
	8650 2750 8750 2850
Entry Wire Line
	8650 2850 8750 2950
Entry Wire Line
	8650 2950 8750 3050
Entry Wire Line
	9850 1450 9950 1550
Entry Wire Line
	9850 1550 9950 1650
Entry Wire Line
	9850 1650 9950 1750
Entry Wire Line
	9850 1750 9950 1850
Entry Wire Line
	9850 1850 9950 1950
Entry Wire Line
	9850 1950 9950 2050
Entry Wire Line
	9850 2050 9950 2150
Entry Wire Line
	9850 2150 9950 2250
Wire Bus Line
	6000 700  8050 700 
Wire Bus Line
	8050 700  9950 700 
Connection ~ 8050 700 
Wire Bus Line
	5900 600  6550 600 
Wire Bus Line
	6550 600  8650 600 
Connection ~ 6550 600 
$Sheet
S 8600 4200 1100 1900
U 5D9CAFE3
F0 "bus-z180" 50
F1 "bus-z180.sch" 50
$EndSheet
$Sheet
S 2350 3300 1050 1100
U 5D97734C
F0 "serial_port" 50
F1 "serial_port.sch" 50
$EndSheet
$Comp
L Oscillator:ACO-xxxMHz X1
U 1 1 5D97AB14
P 3200 1850
F 0 "X1" H 2857 1896 50  0000 R CNN
F 1 "ACO-xxxMHz" H 2857 1805 50  0000 R CNN
F 2 "Oscillator:Oscillator_DIP-14" H 3650 1500 50  0001 C CNN
F 3 "http://www.conwin.com/datasheets/cx/cx030.pdf" H 3100 1850 50  0001 C CNN
	1    3200 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 1850 3500 1850
$Comp
L power:+5V #PWR0107
U 1 1 5D980AF5
P 3200 1400
F 0 "#PWR0107" H 3200 1250 50  0001 C CNN
F 1 "+5V" H 3215 1573 50  0000 C CNN
F 2 "" H 3200 1400 50  0001 C CNN
F 3 "" H 3200 1400 50  0001 C CNN
	1    3200 1400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0108
U 1 1 5D981039
P 3200 2250
F 0 "#PWR0108" H 3200 2000 50  0001 C CNN
F 1 "GND" H 3205 2077 50  0000 C CNN
F 2 "" H 3200 2250 50  0001 C CNN
F 3 "" H 3200 2250 50  0001 C CNN
	1    3200 2250
	1    0    0    -1  
$EndComp
Wire Wire Line
	3200 1400 3200 1550
Wire Wire Line
	3200 2150 3200 2250
$Comp
L Power_Supervisor:TL7705B U4
U 1 1 5DB4BA28
P 2300 6200
F 0 "U4" H 2300 6781 50  0000 C CNN
F 1 "TL7705B" H 2300 6690 50  0000 C CNN
F 2 "Housings_DIP:DIP-8_W7.62mm" H 2300 6200 50  0001 C CNN
F 3 "http://www.ti.com.cn/cn/lit/ds/symlink/tl7705b.pdf" H 2300 6200 50  0001 C CNN
	1    2300 6200
	1    0    0    -1  
$EndComp
Text HLabel 3400 3400 0    50   Input ~ 0
TX1
Text HLabel 3400 3600 0    50   Output ~ 0
RX1
Text HLabel 3400 3700 0    50   Output ~ 0
RTS1
Text HLabel 3400 3800 0    50   Output ~ 0
CTS1
Text HLabel 3400 3900 0    50   Output ~ 0
DCD1
Text HLabel 3400 4100 0    50   Output ~ 0
TX2
Text HLabel 3400 4300 0    50   Output ~ 0
RX2
Text HLabel 8600 4550 2    50   Output ~ 0
~RD~
Text HLabel 8600 4650 2    50   Output ~ 0
~WR~
Text HLabel 8600 4750 2    50   Output ~ 0
~MREQ~
Text HLabel 8600 4850 2    50   Output ~ 0
~IORQ~
Text HLabel 8600 4950 2    50   Output ~ 0
~BUSREQ~
Text HLabel 8600 5050 2    50   Output ~ 0
~BUSACK~
Text HLabel 8600 5150 2    50   Output ~ 0
~M1~
Text HLabel 8600 5350 2    50   Output ~ 0
~WAIT~
Wire Wire Line
	5650 4650 7850 4650
Wire Wire Line
	5650 4750 8600 4750
Wire Wire Line
	5650 4850 8600 4850
Wire Wire Line
	7800 2650 7850 2650
Wire Wire Line
	7850 2650 7850 4650
Connection ~ 7850 4650
Wire Wire Line
	7850 4650 8600 4650
Wire Wire Line
	8900 3550 8150 3550
Wire Wire Line
	8150 3550 8150 4550
Connection ~ 8150 4550
Wire Wire Line
	8150 4550 8600 4550
Wire Wire Line
	5650 4950 8600 4950
Wire Wire Line
	5650 5050 8600 5050
Wire Wire Line
	5650 5350 8600 5350
Text HLabel 8600 4400 2    50   Output ~ 0
~CSRAM~
Text HLabel 8600 4300 2    50   Output ~ 0
~CSROM~
Wire Wire Line
	8600 4300 8500 4300
Wire Wire Line
	8500 4300 8500 3450
Wire Wire Line
	8500 3450 8900 3450
Wire Wire Line
	8600 4400 8400 4400
Wire Wire Line
	8400 4400 8400 2450
Wire Wire Line
	7800 2450 8400 2450
Wire Wire Line
	5650 4550 7950 4550
Wire Wire Line
	7800 2550 7950 2550
Wire Wire Line
	7950 2550 7950 4550
Connection ~ 7950 4550
Wire Wire Line
	7950 4550 8150 4550
Wire Wire Line
	5650 5150 8600 5150
Wire Wire Line
	3400 4300 4250 4300
Wire Wire Line
	3400 3400 4250 3400
Wire Wire Line
	3400 3600 4250 3600
Wire Wire Line
	3400 3700 4250 3700
Wire Wire Line
	3400 3800 4250 3800
Wire Wire Line
	3400 3900 4250 3900
Wire Wire Line
	3400 4100 4250 4100
Wire Bus Line
	8650 600  10050 600 
Connection ~ 8650 600 
$Comp
L power:GND #PWR0109
U 1 1 5DD0B24C
P 8800 3850
F 0 "#PWR0109" H 8800 3600 50  0001 C CNN
F 1 "GND" H 8805 3677 50  0000 C CNN
F 2 "" H 8800 3850 50  0001 C CNN
F 3 "" H 8800 3850 50  0001 C CNN
	1    8800 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	8900 3350 8800 3350
Wire Wire Line
	8800 3350 8800 3850
$Comp
L power:+5V #PWR0110
U 1 1 5DD12A92
P 8550 3200
F 0 "#PWR0110" H 8550 3050 50  0001 C CNN
F 1 "+5V" H 8565 3373 50  0000 C CNN
F 2 "" H 8550 3200 50  0001 C CNN
F 3 "" H 8550 3200 50  0001 C CNN
	1    8550 3200
	1    0    0    -1  
$EndComp
Wire Wire Line
	8550 3200 8550 3250
Wire Wire Line
	8550 3250 8900 3250
Text Label 9250 700  2    50   ~ 0
D[0..7]
Text Label 9250 600  2    50   ~ 0
A[0.19]
Text GLabel 10050 700  2    50   Input ~ 0
D[0..7]
Wire Bus Line
	9950 700  10050 700 
Wire Bus Line
	8050 700  8050 2250
Wire Bus Line
	6000 700  6000 4450
Wire Bus Line
	9950 700  9950 2250
Wire Bus Line
	8650 600  8650 2950
Wire Bus Line
	5900 600  5900 3450
Wire Bus Line
	6550 600  6550 3150
Connection ~ 9950 700 
Text GLabel 10050 600  2    50   Input ~ 0
A[0..19]
$EndSCHEMATC
