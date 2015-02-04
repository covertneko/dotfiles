Config  { font   = "xft:Open Sans:style=Regular:size=10:antialias=true"
        , bgColor = "#002b36"
        , fgColor = "#839496"
        , position = TopW L 90
        , lowerOnStart = True
        , commands = [ Run Weather "KVUO" [ "-t", " <tempC>°C <skyCondition>", "-L", "5", "-H", "30", "--normal", "green", "--high", "red", "--low",  "lightblue" ] 36000
                     , Run MultiCpu [ "-t", "CPU: <total0> <total1> <total2> <total3>", "-L", "30", "-H", "60", "--normal", "green", "--high", "red" ] 10
                     , Run Memory [ "-t", "Mem: <usedratio>%" ] 10
                     , Run Swap [] 10
                     , Run Date "%a, %b %_d, %l:%M" "date" 10
                     , Run StdinReader
                     ]
        , sepChar = "%"
        , alignSep = "}{"
        , template = "%StdinReader% }{ %multicpu% | %memory% | %swap%               <fc=#ee9a00>%date%</fc> | %KVUO%"
