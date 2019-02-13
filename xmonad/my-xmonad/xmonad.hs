 {-# LANGUAGE OverloadedStrings #-}
 {-# LANGUAGE BangPatterns #-}


module Main (main) where

import Bash
import InfoBars
import Keys
import Hooks
--------------------------------------------------------------------------------

import XMonad
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys,additionalKeysP,removeKeysP,checkKeymap)
import XMonad.Config.Desktop(desktopConfig)
--------------------------------------------------------------------------------

import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks

---
import Data.Text
import Turtle


daemons :: [Daemon]
daemons = [
    OneTime "kb" []
  , OneTime "unclutter" []  ]


data Daemon = OneTime { cmd :: Text, args :: [Text] } deriving (Eq, Show, Ord)

wake :: MonadIO io => Daemon -> io ExitCode
wake x@OneTime{} = proc (cmd x) (args x) ""

wake_daemons :: MonadIO io => io ()
wake_daemons = mapM_ wake daemons
--------------------------------------------------------------------------------

myConfig = desktopConfig
          `removeKeysP` forbiddenKeys
          `additionalKeys` myKeys
          `additionalKeysP` theKeys


main ::IO ()
main = do
  say "Peace is a lie"
  wake_daemons
  !workspaceBar <- spawnPipe logBar
  mapM_ spawnPipe infoBars
  xmonad . docks $ myConfig
      { modMask            = myMod
      , terminal           = "konsole"
      , workspaces         = myWorkspaces
      , manageHook         = manageHook myConfig <+> myManageHook 
      , layoutHook         = layoutHook myConfig -- avoidStruts  (layoutHook myConfig)
      , handleEventHook    = handleEventHook myConfig <+> docksEventHook 
      , startupHook        = startupHook myConfig <+> docksStartupHook  <+> return () >> checkKeymap myConfig theKeys
      , logHook            = myLogHook workspaceBar >> fadeInactiveLogHook 0.8
      , borderWidth        = 4
      , normalBorderColor  = "#000000"
      , focusedBorderColor = "#7B68EE"
      }
