Config  { font   = "xft:DejaVu Sans:style=Regular:size=10:antialias=true"
        , bgColor = "#1D1F21"
        , fgColor = "#C5C8C6"
        , position = TopSize L 90 25
        , border = BottomB
        , borderColor = "#1D1F21"
        , borderWidth = 0
        , lowerOnStart = True
        , commands = [ Run Weather "KVUO" [ "-t", " <tempC>°C, <skyCondition>"
                                          , "-L", "5", "-H", "30"
                                          , "--normal", "#859900"
                                          , "--high", "#dc322f"
                                          , "--low",  "#268bd2" ] 36000
                     , Run MultiCpu [ "-t", "CPU: <total0> <total1> <total2> <total3>"
                                    , "-L", "30", "-H", "60"
                                    , "--normal", "#859900"
                                    , "--high", "#dc322f" ] 10
                     , Run Memory [ "-t", "Mem: <usedratio>%" ] 10
                     , Run Swap [] 10
                     , Run Date "%a, %b %_d, %l:%M" "date" 10
                     , Run StdinReader
                     ]
        , sepChar = "%"
        , alignSep = "}{"
        , template = "%StdinReader% }{ %multicpu% | %memory% | %swap%               <fc=#fdf6e3>%date%</fc> | %KVUO%"
