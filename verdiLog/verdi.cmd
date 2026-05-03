verdiSetActWin -dock widgetDock_<Message>
simSetSimulator "-vcssv" -exec "/home/st54/HW4/simv" -args
debImport "-dbdir" "/home/st54/HW4/simv.daidir"
debLoadSimResult /home/st54/HW4/waves.fsdb
wvCreateWindow
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcTBInvokeSim
verdiSetActWin -win $_InteractiveConsole_3
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
wvGetSignalOpen -win $_nWave2
wvSetCursor -win $_nWave2 165.579926
wvAddAllSignals -win $_nWave2
srcHBSelect "top.tb" -win $_nTrace1
srcSetScope "top.tb" -delim "." -win $_nTrace1
srcHBSelect "top.tb" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
wvGetSignalOpen -win $_nWave2
verdiSetActWin -win $_nWave2
srcHBSelect "top.tb" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBSelect "top.tb" -win $_nTrace1
srcHBSelect "top.tb" -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave2
wvUnknownSaveResult -win $_nWave2 -clear
srcHBSelect "top" -win $_nTrace1
srcSetScope "top" -delim "." -win $_nTrace1
srcHBSelect "top" -win $_nTrace1
srcHBSelect "top" -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave2
verdiSetActWin -win $_nWave2
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave2
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave2
wvGetSignalOpen -win $_nWave2
verdiDockWidgetSetCurTab -dock widgetDock_<Decl._Tree>
verdiSetActWin -dock widgetDock_<Decl._Tree>
verdiDockWidgetSetCurTab -dock widgetDock_<Stack>
verdiSetActWin -dock widgetDock_<Stack>
