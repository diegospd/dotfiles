 {-# LANGUAGE OverloadedStrings #-}
 {-# LANGUAGE BangPatterns #-}

module Main (main) where

import Bash
import InfoBars
import Keys
import Hooks
import Daemons

import XMonad
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys,additionalKeysP,removeKeysP,checkKeymap)
import XMonad.Config.Desktop(desktopConfig)

import XMonad.Hooks.SetWMName
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spiral -- TODO move to hooks

import Data.Text
import Turtle
import Control.Concurrent(forkIO)

daemons :: [Daemon]
daemons = [
    OneTime "kb" []
  , OneTime "espeak" ["waking daemons"]
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
  -- wake_daemons
  -- say "Present Day, .. X,Present Time!"
  -- !_ <- forkIO wake_daemons
  spawn "unclutter"
  spawn "kb"
  -- spawn "dunst"
  !workspaceBar <- spawnPipe logBar
  mapM_ spawnPipe infoBars
  xmonad . docks $ myConfig
      { modMask            = myMod
      , terminal           = "cool-retro-term" --"konsole --profile dieg"
      , workspaces         = myWorkspaces
      , manageHook         = manageHook myConfig <+> myManageHook 
      , layoutHook         = avoidStruts $ spiral (6/7) ||| layoutHook myConfig -- avoidStruts  (layoutHook myConfig)
      , handleEventHook    = handleEventHook myConfig <+> docksEventHook 
      , startupHook        = startupHook myConfig <+> docksStartupHook  <+> return () >> checkKeymap myConfig theKeys
      , logHook            = myLogHook workspaceBar >> fadeInactiveLogHook 0.8 >> setWMName "LG3D" --todo: because of intellij
      , borderWidth        = 4
      , normalBorderColor  = "#000000"
      , focusedBorderColor = "#7B68EE"
      }
