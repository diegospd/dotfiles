 {-# LANGUAGE OverloadedStrings #-}
module Hooks ( myLogHook, myWorkspaces, myManageHook ) where

import InfoBars(conkyIcon)

import GHC.IO.Handle.Types
import System.IO(hPutStrLn)
import Data.Monoid(Endo)

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks



myWorkspaces :: [String]
myWorkspaces = [">   1:tmp", "2:web", "3:webλ", "4:tesis", "5:floats", "6:comm" ,"7:admin", "8:daemon", "9:buffer"]

mySpace :: Int -> String
mySpace n = myWorkspaces !! (n-1)

--------------------------------------------------------------------------------------------


-- You can use xprop to find the class name of a window. Run the following command and click on the sxiv window:
-- $ xprop | grep WM_CLASS
myManageHook :: Query (Endo WindowSet)
myManageHook = manageDocks <+> (composeAll . concat)
    [ [ className   =? c --> doIgnore              | c <- myFloats]
    , [ title       =? t --> doFloat               | t <- myOtherFloats]
    , [ className   =? c --> (doShift . mySpace) 8 | c <- myDaemon]
    , [ className   =? c --> (doShift . mySpace) 6 | c <- myComm]
    ]
  where myFloats      = [ "vdpau", "mplayer", "Gimp",  "plasmashell"] --"kwalletd5", "MPlayer",
        myOtherFloats = ["alsamixer", "MPlayer", "vdpau", "mplayer" ]
        myDaemon      = [] -- ["Spotify", "ksysguard", "ktorrent"]  
        myComm        = [] -- ["Xchat"] 


---------------------------------------------------------------------------------
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
