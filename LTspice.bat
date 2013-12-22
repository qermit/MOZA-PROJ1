ECHO OFF
if %PROCESSOR_ARCHITECTURE%==x86 (
  "C:\Program Files\LTC\LTspiceIV\scad3.exe" %1 %2 %3 %4 %5 %6 %7 %8 %9
) else (
  "C:\Program Files (x86)\LTC\LTspiceIV\scad3.exe" %1 %2 %3 %4 %5 %6 %7 %8 %9
)
