% This function will generate the initial code of L2CL generation


function GPS_L2CL_Ini = GPS_L2CL_Ini_Table( )


GPS_L2CL_Ini = [  -1 -1 +1 +1 -1 +1 -1 +1 +1 +1 +1 -1 -1 +1 +1 -1 +1 -1 -1 -1 -1 -1 -1 -1 +1 -1 +1 ;     % PRN 1
                  -1 +1 -1 +1 +1 +1 -1 -1 +1 -1 -1 +1 +1 +1 -1 +1 +1 +1 +1 -1 -1 -1 -1 +1 +1 -1 +1 ;     % PRN 2
                  +1 -1 +1 +1 -1 +1 +1 +1 +1 +1 -1 -1 -1 -1 +1 +1 +1 +1 +1 +1 +1 +1 +1 -1 -1 -1 +1 ;     % PRN 3
                  -1 -1 -1 +1 +1 -1 +1 +1 +1 -1 +1 +1 +1 +1 +1 -1 -1 +1 +1 +1 -1 +1 +1 +1 -1 +1 +1 ;     % PRN 4
                  +1 +1 +1 +1 +1 +1 +1 +1 -1 +1 +1 -1 -1 +1 +1 +1 -1 -1 +1 -1 -1 -1 +1 +1 -1 +1 -1 ;     % PRN 5
                  +1 +1 +1 -1 +1 -1 +1 -1 -1 +1 +1 +1 +1 -1 +1 +1 -1 -1 +1 -1 -1 +1 -1 +1 -1 -1 +1 ;     % PRN 6
                  -1 -1 +1 -1 +1 -1 +1 -1 +1 -1 +1 -1 +1 -1 +1 +1 +1 -1 +1 -1 +1 -1 -1 -1 -1 -1 +1 ;     % PRN 7
                  +1 -1 +1 +1 +1 +1 -1 -1 +1 +1 +1 -1 +1 -1 +1 -1 +1 +1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ;     % PRN 8
                  +1 +1 +1 +1 +1 -1 -1 +1 -1 -1 +1 -1 -1 -1 +1 +1 -1 -1 +1 -1 -1 -1 -1 -1 -1 +1 +1 ;     % PRN 9
                  -1 +1 -1 -1 -1 +1 +1 +1 -1 -1 +1 -1 +1 -1 +1 +1 -1 +1 +1 +1 +1 -1 -1 -1 -1 -1 +1 ;     % PRN 10
                  +1 +1 +1 +1 -1 +1 +1 -1 -1 +1 +1 -1 -1 -1 +1 +1 -1 -1 -1 +1 -1 +1 -1 +1 -1 +1 -1 ;     % PRN 11
                  +1 +1 -1 +1 +1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 +1 -1 +1 +1 -1 +1 -1 +1 +1 +1 ;     % PRN 12
                  -1 -1 +1 +1 +1 +1 -1 -1 +1 -1 +1 -1 +1 +1 -1 -1 -1 +1 +1 -1 -1 +1 -1 -1 -1 +1 -1 ;     % PRN 13
                  +1 +1 +1 +1 +1 +1 +1 -1 -1 +1 +1 +1 +1 -1 -1 -1 -1 -1 +1 -1 -1 -1 +1 +1 +1 -1 -1 ;     % PRN 14
                  +1 +1 +1 -1 +1 +1 -1 -1 +1 -1 +1 -1 +1 +1 -1 -1 +1 -1 -1 +1 -1 -1 -1 +1 -1 +1 -1 ;     % PRN 15
                  -1 -1 +1 -1 -1 -1 +1 +1 -1 -1 +1 -1 +1 +1 -1 +1 +1 -1 -1 -1 +1 +1 -1 +1 +1 +1 -1 ;     % PRN 16
                  -1 -1 +1 +1 +1 +1 -1 +1 -1 -1 +1 +1 +1 +1 +1 +1 -1 +1 +1 -1 +1 +1 -1 +1 +1 +1 +1 ;     % PRN 17
                  +1 +1 +1 +1 +1 +1 +1 -1 +1 -1 +1 -1 -1 -1 -1 -1 -1 +1 +1 -1 +1 +1 +1 +1 -1 -1 -1 ;     % PRN 18
                  -1 +1 -1 +1 -1 +1 -1 +1 -1 +1 +1 -1 -1 -1 +1 +1 -1 -1 -1 +1 +1 -1 +1 -1 +1 +1 -1 ;     % PRN 19
                  +1 -1 +1 -1 -1 +1 -1 -1 +1 -1 +1 -1 +1 -1 +1 -1 -1 -1 -1 -1 -1 -1 -1 +1 -1 +1 -1 ;     % PRN 20
                  +1 +1 +1 +1 +1 +1 -1 -1 +1 -1 -1 -1 -1 -1 +1 +1 +1 +1 -1 -1 -1 +1 +1 +1 +1 -1 -1 ;     % PRN 21
                  -1 +1 -1 +1 +1 +1 +1 +1 -1 -1 +1 +1 -1 -1 -1 -1 +1 +1 -1 +1 -1 -1 +1 -1 -1 -1 +1 ;     % PRN 22
                  -1 -1 -1 -1 +1 +1 +1 -1 -1 -1 -1 -1 -1 +1 +1 -1 -1 -1 -1 +1 +1 -1 +1 +1 +1 -1 -1 ;     % PRN 23
                  -1 -1 +1 +1 +1 -1 -1 +1 -1 -1 +1 -1 +1 -1 -1 -1 +1 +1 -1 -1 -1 +1 -1 +1 -1 -1 +1 ;     % PRN 24
                  -1 -1 -1 -1 -1 +1 +1 -1 -1 -1 -1 +1 +1 -1 +1 +1 +1 -1 -1 +1 +1 +1 -1 +1 +1 +1 +1 ;     % PRN 25
                  -1 -1 -1 +1 -1 +1 +1 +1 +1 -1 -1 -1 +1 -1 +1 -1 -1 -1 -1 +1 +1 -1 -1 -1 -1 +1 +1 ;     % PRN 26
                  -1 -1 -1 +1 +1 +1 +1 +1 +1 -1 +1 -1 +1 -1 +1 +1 +1 -1 +1 +1 +1 -1 +1 +1 +1 -1 -1 ;     % PRN 27
                  +1 -1 +1 +1 -1 +1 +1 -1 +1 -1 +1 -1 -1 -1 +1 -1 -1 -1 +1 -1 +1 -1 -1 +1 +1 -1 -1 ;     % PRN 28
                  +1 +1 -1 +1 -1 -1 +1 -1 +1 -1 -1 -1 -1 -1 +1 -1 +1 -1 +1 -1 -1 +1 +1 +1 -1 +1 +1 ;     % PRN 29
                  -1 -1 -1 -1 +1 +1 -1 -1 +1 +1 -1 -1 +1 -1 -1 +1 -1 +1 +1 -1 +1 -1 +1 +1 -1 +1 -1 ;     % PRN 30
                  +1 +1 -1 +1 +1 +1 +1 -1 +1 +1 -1 -1 +1 +1 +1 +1 +1 +1 -1 +1 +1 -1 -1 +1 -1 -1 +1 ;     % PRN 31
                  +1 -1 +1 -1 +1 -1 -1 +1 -1 +1 -1 +1 +1 -1 -1 +1 +1 -1 -1 -1 -1 +1 +1 -1 -1 -1 +1 ;     % PRN 32
                  -1 +1 +1 +1 -1 -1 -1 -1 -1 -1 -1 +1 -1 -1 +1 +1 +1 -1 -1 -1 -1 +1 +1 +1 +1 +1 -1 ;     % PRN 33
                  -1 -1 -1 +1 +1 -1 -1 -1 -1 +1 +1 +1 -1 +1 +1 -1 -1 -1 +1 -1 -1 +1 +1 +1 +1 -1 +1 ;     % PRN 34
                  +1 -1 +1 +1 -1 +1 +1 -1 +1 -1 -1 +1 +1 +1 -1 -1 +1 +1 +1 -1 +1 +1 +1 +1 -1 -1 -1 ;     % PRN 35
                  -1 +1 -1 -1 -1 +1 +1 +1 -1 +1 +1 -1 +1 -1 +1 +1 -1 -1 +1 -1 -1 +1 +1 +1 -1 -1 -1 ;     % PRN 36
                  +1 -1 +1 -1 +1 +1 +1 +1 +1 -1 -1 -1 +1 +1 -1 +1 -1 -1 +1 +1 +1 -1 -1 -1 +1 -1 -1 ;     % PRN 37
                  +1 +1 -1 +1 +1 +1 +1 +1 -1 +1 -1 +1 +1 -1 -1 +1 -1 +1 -1 -1 +1 +1 -1 -1 +1 +1 +1 ;     % PRN 38
                  +1 +1 -1 +1 -1 -1 +1 -1 +1 -1 +1 -1 +1 -1 +1 -1 +1 -1 -1 -1 -1 +1 -1 +1 -1 -1 +1 ;     % PRN 39
                  +1 -1 -1 +1 +1 -1 -1 +1 -1 +1 -1 +1 +1 +1 -1 -1 -1 +1 +1 -1 -1 -1 -1 +1 -1 -1 -1 ;     % PRN 40
                  +1 -1 -1 -1 -1 -1 -1 -1 -1 +1 +1 +1 -1 +1 +1 -1 -1 +1 +1 +1 +1 -1 -1 +1 -1 +1 -1 ;     % PRN 41
                  -1 -1 +1 -1 +1 -1 -1 +1 -1 +1 -1 -1 -1 +1 -1 +1 +1 -1 +1 -1 -1 -1 -1 +1 +1 +1 +1 ;     % PRN 42
                  -1 +1 +1 +1 -1 -1 -1 +1 -1 -1 -1 -1 -1 -1 -1 -1 -1 +1 -1 +1 -1 +1 +1 -1 +1 -1 -1 ;     % PRN 43
                  -1 -1 -1 -1 +1 +1 -1 +1 +1 +1 -1 +1 -1 +1 +1 +1 -1 +1 +1 -1 -1 +1 -1 +1 +1 +1 -1 ;     % PRN 44
                  +1 +1 +1 +1 -1 +1 -1 +1 +1 +1 -1 -1 -1 +1 +1 -1 -1 +1 -1 -1 -1 +1 +1 -1 -1 -1 -1 ;     % PRN 45
                  -1 +1 -1 -1 -1 +1 +1 -1 +1 -1 -1 +1 -1 +1 +1 -1 -1 +1 -1 +1 +1 +1 +1 -1 -1 +1 -1 ;     % PRN 46
                  -1 -1 -1 +1 -1 -1 +1 +1 -1 -1 +1 +1 -1 +1 -1 -1 +1 -1 +1 -1 -1 -1 +1 +1 +1 -1 +1 ;     % PRN 47
                  -1 -1 -1 +1 -1 +1 +1 -1 -1 +1 -1 -1 -1 +1 -1 +1 -1 +1 -1 +1 -1 +1 -1 -1 -1 -1 +1 ;     % PRN 48
                  +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 -1 +1 -1 -1 +1 +1 -1 +1 -1 -1 -1 +1 +1 ;     % PRN 49
                  +1 +1 +1 +1 +1 -1 +1 +1 -1 -1 +1 -1 -1 -1 +1 -1 -1 +1 -1 -1 +1 -1 +1 +1 +1 -1 +1 ;     % PRN 50
                  -1 +1 +1 -1 -1 -1 -1 +1 -1 -1 +1 +1 +1 -1 -1 +1 -1 +1 +1 -1 +1 +1 -1 +1 +1 -1 +1 ;     % PRN 51
                  -1 +1 +1 -1 -1 +1 +1 -1 -1 -1 +1 -1 +1 +1 +1 -1 -1 +1 -1 -1 -1 -1 +1 +1 +1 +1 -1 ;     % PRN 52
                  -1 -1 +1 +1 +1 -1 -1 -1 -1 +1 +1 -1 +1 -1 +1 -1 -1 -1 -1 +1 -1 +1 -1 -1 -1 +1 +1 ;     % PRN 53
                  +1 +1 +1 +1 -1 +1 -1 -1 +1 +1 +1 +1 -1 +1 -1 +1 +1 +1 +1 -1 -1 +1 -1 -1 +1 -1 +1 ;     % PRN 54   
                  -1 -1 -1 +1 -1 -1 +1 -1 -1 -1 -1 -1 -1 -1 -1 -1 +1 +1 +1 -1 +1 +1 -1 -1 -1 +1 -1 ;     % PRN 55
                  -1 -1 -1 -1 +1 -1 +1 +1 -1 -1 +1 +1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 +1 -1 +1 ;     % PRN 56
                  -1 +1 +1 +1 +1 -1 -1 -1 -1 -1 -1 +1 +1 -1 -1 +1 +1 -1 -1 +1 -1 -1 +1 -1 +1 +1 +1 ;     % PRN 57
                  +1 +1 +1 -1 +1 -1 +1 -1 +1 +1 -1 +1 -1 +1 +1 -1 -1 -1 -1 +1 +1 -1 +1 -1 -1 -1 +1 ;     % PRN 58
                  -1 +1 -1 -1 -1 +1 +1 +1 +1 -1 +1 +1 +1 +1 +1 -1 +1 +1 +1 +1 -1 -1 -1 +1 +1 -1 -1 ;     % PRN 59
                  -1 +1 +1 +1 +1 -1 -1 -1 -1 -1 -1 -1 -1 +1 -1 +1 +1 -1 +1 +1 +1 +1 +1 +1 -1 +1 -1 ;     % PRN 60
                  +1 +1 +1 +1 +1 +1 -1 +1 +1 +1 -1 -1 +1 +1 +1 +1 -1 +1 +1 +1 -1 -1 -1 -1 +1 -1 -1 ;     % PRN 61
                  -1 -1 -1 +1 +1 -1 -1 +1 -1 +1 +1 +1 +1 +1 +1 -1 +1 -1 +1 +1 +1 -1 +1 +1 -1 +1 -1 ;     % PRN 62
                  +1 +1 +1 +1 +1 +1 +1 +1 -1 +1 +1 -1 -1 +1 -1 -1 +1 +1 -1 +1 +1 -1 +1 -1 -1 -1 -1 ;     % PRN 63 
               ];

return;



