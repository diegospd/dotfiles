 {-# LANGUAGE OverloadedStrings #-}


module Main (main) where

import Bash
import InfoBars
import Keys
import Hooks
--------------------------------------------------------------------------------
import Data.List
import Data.Monoid(Endo)
import Turtle
import XMonad
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys,removeKeys,additionalKeysP,removeKeysP,checkKeymap)
import XMonad.Config.Desktop(desktopConfig)
--------------------------------------------------------------------------------

-- import System.IO(hPutStrLn)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks


--------------------------------------------------------------------------------

myConfig = desktopConfig
          `removeKeysP` forbiddenKeys
          `additionalKeys` myKeys
          `additionalKeysP` theKeys


myWorkspaces :: [String]
myWorkspaces = [">   1:tmp", "2:web", "3:webλ", "4:tesis", "5:floats", "6:comm" ,"7:admin", "8:daemon", "9:buffer"]


main ::IO ()
main = do
  say "Gimme peas "
  mapM_ kill_if_running ["conky"]
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


