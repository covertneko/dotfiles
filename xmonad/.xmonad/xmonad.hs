import XMonad
import XMonad.StackSet hiding (workspaces)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import Data.List(isInfixOf, concat)

myTerminal = "/usr/bin/urxvt"
myXMobarConfig = "/home/eric/.xmonad/xmobar.hs"

-- Colors from https://chriskempson.github.io/base16/#ocean
colorBase00 = "#2b303b" -- Background
colorBase01 = "#343d46"
colorBase02 = "#4f5b66"
colorBase03 = "#65737e"
colorBase04 = "#a7adba"
colorBase05 = "#c0c5ce" -- Foreground
colorBase06 = "#dfe1e8"
colorBase07 = "#eff1f5" -- White
colorBase08 = "#bf616a" -- Red
colorBase09 = "#d08770" -- Orange
colorBase0A = "#ebcb8b" -- Yellow
colorBase0B = "#a3be8c" -- Green
colorBase0C = "#96b5b4" -- Cyan
colorBase0D = "#8fa1b3" -- Blue
colorBase0E = "#b48ead" -- Magenta
colorBase0F = "#ab7967" -- Brown

myManageHook = composeOne . concat $
  [ [ title =? "Network Operations Manager" -?> doFloat ]
  , [ className =? "Pidgin"                 -?> doShift "1:main" ]
  , [ isDialog                              -?> doFloat ]
  , [ role =? "pop-up"                      -?> doRectFloat
      $ RationalRect 0.5 0.5 0.5 0.5 ]
  -- [ [ fmap ( c `isInfixOf`) resource -?> doFloat | c <- matchTitleSubstringFloats ]
  ]
    where role = stringProperty "WM_WINDOW_ROLE"
    -- where matchTitleSubstringFloats = ["Developer Tools"]

myLayoutHook = tiled ||| Full ||| Mirror tiled
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1/2
    delta = 3/100

main = do
    xmproc <- spawnPipe $ "xmobar " ++ myXMobarConfig
    xmonad $ ewmh defaultConfig
        { workspaces = ["1:main", "2:dev", "3:web", "4", "5", "6", "7", "8", "9", "0", "-", "="]
        , handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook
        , manageHook = manageDocks <+> myManageHook
        , layoutHook = avoidStruts $ smartBorders $ myLayoutHook
        , logHook    = dynamicLogWithPP xmobarPP
                          { ppOutput = hPutStrLn xmproc
                          , ppTitle  = xmobarColor colorBase07 "" . shorten 50
                          , ppCurrent = xmobarColor colorBase0D "" . wrap "[" "]"
                          }
        , borderWidth = 2
        , normalBorderColor = colorBase00
        , focusedBorderColor = colorBase0D
        , terminal = myTerminal
        , modMask = mod4Mask
        }
        `additionalKeys`
        [ ((0, 0x1008FF11), spawn "pulseaudio-ctl down 2")
        , ((0, 0x1008FF13), spawn "pulseaudio-ctl up 2")
        , ((0, 0x1008FF12), spawn "pulseaudio-ctl mute")
        , ( (mod4Mask .|. shiftMask, xK_l),
            spawn "xscreensaver-command -lock"
          )
        ]
