import XMonad
import XMonad.Config.Desktop
import XMonad.Util.EZConfig(additionalKeys)
import qualified XMonad.StackSet as W

-- make cmd/windows key my mod mask
myModMask = mod4Mask

myTerminal = "terminator"

myWorkspaces = ["term", "web", "chat", "dev"] ++ map show [5..9]

-- fling the most commonly used programs for those tasks to those workspaces
myManageHook = (composeAll . concat $
    [ [ className =? x --> doShiftAndGo "term" | x <- termApps ]
    , [ className =? x --> doShiftAndGo "web"  | x <- webApps  ]
    , [ className =? x --> doShiftAndGo "chat" | x <- chatApps ]
    , [ className =? x --> doShiftAndGo "dev"  | x <- devApps  ]
    ]) where
        doShiftAndGo ws = doF (W.greedyView ws) <+> doShift ws
        termApps = ["Terminator"]
        webApps  = ["firefox"]
        chatApps = ["Slack", "TelegramDesktop", "Thunderbird", "trojita"]
        devApps  = ["code-oss"]

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
