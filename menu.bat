@if "%1" == "" GOTO h
@if %1 == g GOTO git
@if %1 == . GOTO exp
@if %1 == n GOTO note
@if %1 == w GOTO word
@if %1 == s GOTO svn
@if %1 == ~ GOTO clean
@if %1 == sd GOTO saveDir
@if %1 == rd GOTO restoreDir
@if %1 == csd GOTO clearSavedDir

@GOTO h
:h
@echo -------------------
@echo functions:
@echo n - notes
@echo g - cd github
@echo s - cd svn
@echo . - open explorer
@echo ~ - clean~
@echo sd- save directory
@echo rd- restore directory
@echo ------------------
@GOTO EOF
:exp
@explorer .
@GOTO EOF
:git
@C:
@cd "C:\Users\Aneesh Durg\Desktop\Work\github\"
@GOTO EOF
:note
@vim "C:\Users\Aneesh Durg\~StickyNotes"
@GOTO EOF
:word
@"C:\Program Files\Microsoft Office 15\root\office15\winword.exe" %2
GOTO EOF
:svn
@cd "C:\Users\Aneesh Durg\Desktop\Work\svn\"
@GOTO EOF
:clean
@clean~
@GOTO EOF
:saveDir
@cd>C:\custom\saveddir%2.txt
@GOTO EOF
:restoreDir
@set /p d=<C:\custom\saveddir%2.txt
@cd %d%
@GOTO EOF
:clearSavedDir
@del C:\custom\saveddir*
@GOTO EOF
:EOF

