@del C:\custom\*~ > nul
@if "%1" == "" GOTO h
@if %1 == g GOTO git
@if %1 == . GOTO exp
@if %1 == n GOTO note
@if %1 == w GOTO word

@GOTO h
:h
@echo -------------------
@echo functions:
@echo n - notes
@echo g - cd github
@echo . - open explorer
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
:EOF

