import XMonad
import XMonad.Config.Desktop
import XMonad.Util.EZConfig(additionalKeys)
import qualified XMonad.StackSet as W

-- make cmd/windows key my mod mask
myModMask = mod4Mask

myTerminal = "terminator"

myWorkspaces = ["term", "web", "chat", "dev"] ++ map show [5..9]

-- fling the most commonly used programs for those tasks to those workspaces
myManageHook = composeAll
    [ className =? "firefox"         --> doShiftAndGo "web"
    , className =? "Terminator"      --> doShiftAndGo "term"
    , className =? "TelegramDesktop" --> doShiftAndGo "chat"
    , className =? "code-oss"        --> doShiftAndGo "dev"
    ] where
        doShiftAndGo ws = doF (W.greedyView ws) <+> doShift ws

-- M-S-Fn flings window to workspace n and switches to it
myKeys = [ ((shiftMask .|. myModMask, k), windows $ W.greedyView i . W.shift i)
    | (i, k) <- zip myWorkspaces [xK_F1..xK_F9]
    ]

main = do
    xmonad $ desktopConfig 
        { modMask = myModMask
        , terminal = myTerminal
        , workspaces = myWorkspaces
        , manageHook = myManageHook <+> manageHook desktopConfig
        } `additionalKeys` myKeys
