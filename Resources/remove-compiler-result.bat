@echo off
echo --------
echo This will remove added files from compiler
timeout /T -1
cd ..
del "Run-Gadget.ahk"
del "Run-Gadget-Elevated.ahk"
del "Run-Gadget-V1.ahk"
cd Modules
del ".include" /S
del "== Create Script.ahk" /S