 {-# LANGUAGE OverloadedStrings #-}
module Hooks ( myLogHook ) where

import InfoBars(conkyIcon)

import GHC.IO.Handle.Types
import System.IO(hPutStrLn)

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks

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
