
-- Referencias para moverle aquí:
-- http://thinkingeek.com/2011/11/21/simple-guide-configure-xmonad-dzen2-conky/
-- https://braincrater.wordpress.com/2008/11/02/pimp-your-xmonad-1-status-bars/
-- https://wiki.haskell.org/Xmonad/Config_archive/John_Goerzen's_Configuration#Installing_xmobar
-- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-DynamicLog.html#v:dynamicLogWithPP

-- Esta configuración es para que xmonad corra sobre plasma.
-- La saqué de aquí.
-- https://wiki.haskell.org/Xmonad/Using_xmonad_in_KDE
-- julio 31 2016


-- deals with docks and taskbars
-- sets the default terminal to konsole
-- sets mod-p to run popup
-- sets mod-shift-q to logout properly.

-- holy grail

import System.IO
import Data.Monoid(Endo)
import Data.List

import InfoBars (logBar, infoBars, conkyIcon)
import Keys

import XMonad
import XMonad.Util.Run  
import XMonad.Config.Kde
import XMonad.Util.EZConfig           -- additionalKeys
import XMonad.Hooks.DynamicLog        -- para myLogHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive  
import qualified XMonad.StackSet as W -- to shift and float windows







-- toggleKMouse :: MyState -> MyState
-- toggleKMouse st = st {keyboardMouse = not $ keyboardMouse st}



-- TODO: Not in scope "f" quizá si usas lenses si puedas
-- toggleState :: (MyState -> Bool) -> MyState -> MyState
-- toggleState f st = st {f = not . f $ st} 


-- goku io = do
--     st <- XS.get
--     if keyboardMouse st
--         then io
--         else return ()




-------------------------------------------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------------------------------------------
myConfig = kde4Config `removeKeysP` forbiddenKeys `additionalKeys` myKeys `additionalKeysP` theKeys

main :: IO ()
main = do
    -- spawn "/home/diego/storage/bin/kb" -- "echo \"kb\" | bash"
    -- spawn "redshift -l 19.320912:-99.143774"
    spawn "espeak 'Reinitializing all lambda systems.'"
    workspaceBar <- spawnPipe logBar
    mapM_ spawnPipe infoBars
    xmonad . docks $ myConfig
        { modMask            = myMod 
        , workspaces         = myWorkspaces
        , manageHook         = manageHook myConfig <+> myManageHook <+> manageDocks 
        , layoutHook         = avoidStruts  (layoutHook myConfig)
        , handleEventHook    = handleEventHook myConfig <+> docksEventHook 
        , startupHook        = startupHook myConfig <+> docksStartupHook  <+> return () >> checkKeymap myConfig theKeys
        , logHook            = myLogHook workspaceBar >> fadeInactiveLogHook 0xdddddddd
        , borderWidth        = 4
        , normalBorderColor  = "#000000"
        , focusedBorderColor = "#7B68EE"
        } `additionalKeys` myKeys `additionalKeysP` theKeys


-------------------------------------------------------------------------------------------------------------------
-- Configuraciones para las barras
-------------------------------------------------------------------------------------------------------------------

-- fonts mamalonas
myFonts :: [String]
myFonts = ["clean", "macondo", "zeyada", "aclonica", "warnes", "wallpoet", "vt323", "voltaire", "vast shadow", "text me one" ]


myBg :: String
myFg :: String
myFn :: String
myBg = "#1B1D1E "
myFg = "#FFFFFF"
myFn =  myFonts !! 0 -- 0 3 


-- esto pone el tray en el extremo derecho de la barra de estatus
myStaloneTray :: String
myStaloneTray  = "stalonetray --geometry=" ++show myStaloneSlots++"x1+0+0 --background=" ++ myBg 
  where myStaloneSlots = 2


-------------------------------------------------------------------------------------------------------------------
-- Workspaces
-------------------------------------------------------------------------------------------------------------------

myWorkspaces :: [String]
myWorkspaces = [">   1:tmp", "2:web", "3:webλ", "4:tesis", "5:floats", "6:comm" ,"7:admin", "8:daemon", "9:buffer"]

mySpace :: Int -> String
mySpace n = myWorkspaces !! (n-1)






-------------------------------------------------------------------------------------------------------------------
-- Hooks
-------------------------------------------------------------------------------------------------------------------

myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ def  --defaultPP --dice que está deprecated
    {
        ppCurrent           =   dzenColor "#ebac54" "#FF0022" . pad
      , ppVisible           =   dzenColor "white"   "#1B1D1E" . pad
      , ppHidden            =   dzenColor "white"   "#1B1D1E" . pad
      , ppHiddenNoWindows   =   dzenColor "#7b7b7b" "#1B1D1E" . pad
      , ppUrgent            =   dzenColor "#ff0000" "#FFFFFF" . pad
      , ppWsSep             =   ""
      , ppSep               =   "    " -- gk "pacman.xbm"
      , ppLayout            =   dzenColor "#ebac54" "#1B1D1E" .
                                (\x -> case x of
                                    "Tall"         ->  conkyIcon "tall.xbm"
                                    "Mirror Tall"  ->  conkyIcon "mtall.xbm"
                                    "Full"         ->  conkyIcon "full.xbm"
                                    "Simple Float" ->  "~"
                                    _              ->  x
                                ) 
      , ppTitle             =   (" " ++) . dzenColor "white" "#1B1D1E" . dzenEscape
      , ppOutput            =   hPutStrLn h
    }
    where gk icon = "^i(" ++ myBitmapsDir ++ "/" ++ icon ++ ")"

-- acá están los íconos
-- myBitmapsDir :: String
myBitmapsDir = "/home/diego/.xmonad/dzen2"


-- You can use xprop to find the class name of a window. Run the following command and click on the sxiv window:
-- $ xprop | grep WM_CLASS
myManageHook :: Query (Endo WindowSet)
myManageHook = composeAll . concat $
    [ [ className   =? c --> doIgnore              | c <- myFloats]
    , [ title       =? t --> doFloat               | t <- myOtherFloats]
    , [ className   =? c --> (doShift . mySpace) 8 | c <- myDaemon]
    , [ className   =? c --> (doShift . mySpace) 6 | c <- myComm]
    ]
  where myFloats      = [ "vdpau", "mplayer", "Gimp",  "plasmashell"] --"kwalletd5", "MPlayer",
        myOtherFloats = ["alsamixer", "MPlayer", "vdpau", "mplayer" ]
        myDaemon      = [] -- ["Spotify", "ksysguard", "ktorrent"]  
        myComm        = [] -- ["Xchat"]           
