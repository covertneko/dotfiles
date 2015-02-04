import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
		    { manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook    = dynamicLogWithPP xmobarPP
                          { ppOutput = hPutStrLn xmproc
                          , ppTitle  = xmobarColor "green" "" . shorten 50
                          }
        , borderWidth = 2
        , normalBorderColor = "#002b36"
        , focusedBorderColor = "#ffffff"
        , terminal = "urxvt"
        , modMask = mod4Mask
        } `additionalKeys`
        [ ((0                     , 0x1008FF11), spawn "pulseaudio-ctl down 2")
        , ((0                     , 0x1008FF13), spawn "pulseaudio-ctl up 2")
        , ((0                     , 0x1008FF12), spawn "pulseaudio-ctl mute")
        , ((mod4Mask .|. shiftMask, xK_L), spawn "xscreensaver-command -lock")
        ]
