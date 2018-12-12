 {-# LANGUAGE OverloadedStrings #-}


module Main (main) where

import Bash
import InfoBars
import Keys
--------------------------------------------------------------------------------
import System.IO(hPutStrLn)
import Data.List
import Data.Monoid(Endo)
import Turtle
import XMonad
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys,removeKeys,additionalKeysP,removeKeysP,checkKeymap)
import XMonad.Config.Desktop(desktopConfig)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

myConfig = desktopConfig
          `removeKeysP` forbiddenKeys
          `additionalKeys` myKeys
          `additionalKeysP` theKeys


myWorkspaces :: [String]
myWorkspaces = [">   1:tmp", "2:web", "3:webλ", "4:tesis", "5:floats", "6:comm" ,"7:admin", "8:daemon", "9:buffer", "0:x"]


main ::IO ()
main = do
  -- say "it works! my good luck"
  say "Initializing all lambda systems"
  -- mapM_ kill_if_running ["conky", "dzen2"]
  -- fix_keyboard
  -- wake_daemons
  workspaceBar <- spawnPipe logBar
  mapM_ spawnPipe infoBars
  xmonad . docks $ myConfig
      { modMask            = myMod
      , terminal           = "konsole"
      , workspaces         = myWorkspaces
      , manageHook         = manageHook myConfig <+> manageDocks 
      , layoutHook         = avoidStruts  (layoutHook myConfig)
      , handleEventHook    = handleEventHook myConfig <+> docksEventHook 
      , startupHook        = startupHook myConfig <+> docksStartupHook  <+> return () >> checkKeymap myConfig theKeys
      , logHook            = myLogHook workspaceBar >> fadeInactiveLogHook 0xdddddddd
      , borderWidth        = 4
      , normalBorderColor  = "#000000"
      , focusedBorderColor = "#7B68EE"
      }






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


