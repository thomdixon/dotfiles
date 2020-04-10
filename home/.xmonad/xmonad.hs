import XMonad
import XMonad.Config.Desktop

myWorkspaces = ["term","web","chat","code"] ++ map show [5..9]

main = xmonad desktopConfig 
        { modMask = mod4Mask
        , terminal = "terminator"
        , workspaces = myWorkspaces
        }
