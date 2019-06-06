{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BangPatterns #-}


module Keys (myKeys, theKeys, forbiddenKeys, myMod) where

import XMonad
import XMonad.Actions.WindowBringer


import Bash
import Prelude hiding (sequence)
import GHC.Base(when)
import Turtle(sleep)
import Control.DeepSeq

import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W -- to shift and float windows
import qualified XMonad.Util.ExtensibleState as XS

-- TODO take mouse to active screen

myMod :: KeyMask
myMod = mod4Mask

type Ninjutsu   = String  --  "M-S x"
type KeyBinding = (Ninjutsu, X())
type Command    = String  --  "echo 'asi es'"

theKeys :: [KeyBinding]
theKeys = admin
       ++ windowBringer
       ++ multimedia 
       ++ launchers   
       ++ mouseKeys 
       ++ dolphin
       ++ konsole
       ++ nu

forbiddenKeys :: [Ninjutsu]
-- Plasma uses this sequence to trigger its own workspace
-- switcher. 
-- TODO Fix this
forbiddenKeys = ["M-q"]
-- TODO switch to emacs
myKeys = numpadSwitcher

windowBringer :: [KeyBinding]
windowBringer = [ ("M-g", gotoMenu) 
                , ("M-S-g", bringMenu)]

   
-- Emacs style key sequecences
-- https://hackage.haskell.org/package/xmonad-contrib-0.13/docs/XMonad-Util-EZConfig.html
launchers :: [KeyBinding]
launchers = 
    [
      ("M-/", spawn chromium)
    , ("M-S-/", spawn chrome)
    , ("M-m", spawn "ksysguard")
    , ("M-v", spawn "keepassxc")
    , ("M-S-v", spawn "keepassx")
    , ("M-x x", openSubl "")
    , ("M-x k", openSubl "~/.dotfiles/xmonad/Keys.hs")
    , ("M-x i", openSubl "~/.dotfiles/xmonad/InfoBars.hs")
    , ("M-x z", openSubl "~/.zshrc")
    , ("M-x .", openSubl "~/.dotfiles")
    , ("M-x p", openSubl "~/storage/codigos/haskell/pol")
    , ("M-S-<KP_Enter>", spawn "konsole -e ~/.local/bin/pol")
    , ("M-S-<KP_Subtract>", spawn "echo \"cd ~/storage/crypto/tor-browser_en-US && ./start-tor-browser.desktop\" | bash")
    , ("M-i", spawn "flameshot gui")
    ]

openSubl :: String -> X ()
openSubl path = spawn $ "subl3 --new-window " <> path

multimedia :: [KeyBinding]
multimedia =  
    [
      ("M-<KP_Add>", spawn $ spotify "PlayPause")
    , ("M-<KP_Multiply>", spawn $ spotify "Previous")
    , ("M-<KP_Subtract>", spawn $ spotify "Next")
    ]

spotify :: String -> String
spotify = (++) "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player."

launch_and_play :: X ()
launch_and_play = do
    !running <- is_running "spotify"
    !check <- when (not running) $ do
        spawn "spotify"
        sleep 5.0
    !go <- spawn $ spotify "PlayPause"
    return ()
    


dolphin :: [KeyBinding] 
dolphin =
    [
      ("M-d <Return>", runDolphin "~/")
    , ("M-S-d", runDolphin "~/" )

    , ("M-d s", runDolphin "~/shelf")
    , ("M-d w", runDolphin "~/storage")

    , ("M-d t", runDolphin "~/textos")
    , ("M-d d", runDolphin "~/Dropbox")
    , ("M-d .", runDolphin "~/.dotfiles")
    , ("M-d x <Return>", runDolphin "~/.dotfiles/xmonad")

    , ("M-d v", runDolphin "~/shelf/video")
    , ("M-d i", runDolphin "~/shelf/img")

    , ("M-d l", runDolphin "~/storage/libros")
    , ("M-d c", runDolphin "~/storage/docs/cv")
    , ("M-d j", runDolphin "~/storage/codigos/chambas")
    ] 


konsole :: [KeyBinding] 
konsole =
    [
      ("M-\\ s", spawn $ cmd "~/shelf")
    , ("M-\\ d", spawn $ cmd "~/Dropbox")
    , ("M-\\ v", spawn $ cmd "~/shelf/video/")
    , ("M-\\ x", spawn $ cmd "~/.dotfiles/xmonad/")
    ]
    where cmd = (<>) "konsole --profile dieg --workdir "



admin :: [KeyBinding]
admin =
    [
      ("M-p", run_rofi)
    , ("M-o", run_rofi)
    , ("M-b", toggleBars)
    , ("M-a p", run_rofi)
    , ("M-a <Backspace>", spawn "xmonad-x86_64-linux --restart")
    , ("M-a =", spawn "xmonad-x86_64-linux --recompile && xmonad-x86_64-linux --restart")
    , ("M-a a", say "I alway lie. Even right now. Please laugh.")
    , ("M-a b", spawn restart_pulseaudio)
    , ("M-a s", spawn "systemsettings5")
    ]

nu :: [KeyBinding]
nu = [("M-d n", runDolphin "$NU_HOME/" )]

---------------------------------------------------------------------------------
--            Commands
---------------------------------------------------------------------------------

chrome :: Command
chrome = "google-chome-stable --password-store=basic"

chromium :: Command
chromium = "chromium --password-store=basic"

restart_pulseaudio :: Command
restart_pulseaudio = "pulseaudio -k || pulseaudio --start"

run_rofi = spawn $ unwords
    [ "rofi -show run -modi run -location 1 -width 100 -yoffset 24"
    , "-lines 2 -line-margin 0 -line-padding 1"
    , "-separator-style none -font \"mono 10\" -columns 9 -bw 0"
    , "-hide-scrollbar"
    , "-color-window \"#222222, #222222, #b1b4b3\""
    , "-color-normal \"#222222, #b1b4b3, #222222, #005577, #b1b4b3\""
    , "-color-active \"#222222, #b1b4b3, #222222, #007763, #b1b4b3\""
    , "-color-urgent \"#222222, #b1b4b3, #222222, #77003d, #b1b4b3\""
    , "-kb-row-select \"Tab\" -kb-row-tab \"\""
    ]

runDolphin :: String -> X()
runDolphin path = spawn $ "dolphin " <> path

-------------------------------------------------------------------------------------------------------------------
-- MyKeys
-- https://hackage.haskell.org/package/X11-1.8/docs/src/Graphics-X11-Types.html
-------------------------------------------------------------------------------------------------------------------


numpadSwitcher :: [((ButtonMask, KeySym), X ())] 
numpadSwitcher = 
    [
      ((m .|. myMod, k), windows $ f i)
      | (i, k) <- zip myWorkspaces myNumPadWorkspaces
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ]
myWorkspaces :: [String]
myWorkspaces = [">   1:tmp", "2:web", "3:webλ", "4:tesis", "5:floats", "6:comm" ,"7:admin", "8:daemon", "9:buffer"]
-- para cambiar de workspaces usando el teclado numerico.
myNumPadWorkspaces :: [KeySym]
myNumPadWorkspaces = [ xK_KP_End,  xK_KP_Down,  xK_KP_Page_Down -- 1, 2, 3
                     , xK_KP_Left, xK_KP_Begin, xK_KP_Right     -- 4, 5, 6
                     , xK_KP_Home, xK_KP_Up,    xK_KP_Page_Up   -- 7, 8, 9
                     ]


------------------------------------------------------------------------------------------------------------------
-- Auxiliares para keys
-------------------------------------------------------------------------------------------------------------------
-- https://www.reddit.com/r/xmonad/comments/5heeyo/how_i_move_my_mousecursor_on_xmonad/

mouseKeys :: [KeyBinding]
mouseKeys = 
    [
      ("M-M1-<Up>", moveMouse 0  $ -10)
    , ("M-M1-C-<Up>", moveMouse 0 $ -50)
    , ("M-M1-<Down>", moveMouse 0 10)
    , ("M-M1-C-<Down>", moveMouse 0 50)
    , ("M-M1-<Left>", moveMouse  (-10) 0)
    , ("M-M1-C-<Left>", moveMouse (-50) 0)
    , ("M-M1-<Right>", moveMouse 10 0)
    , ("M-M1-C-<Right>", moveMouse 50 0)
    , ("M-M1-<KP_Insert>", spawn "xdotool click 1")
    , ("M-M1-C-<KP_Insert>", spawn "xdotool click 3")
    -- , ("M-C-<Up>", spawn "xdotool click 4")
    -- , ("M-C-<Down>", spawn "xdotool click 5")
    -- , ("M-C-<Left>", spawn "xdotool click Left")
    -- , ("M-C-<Right>", spawn "xdotool click Right")
    ]
moveMouse :: Int -> Int -> X ()
moveMouse x y = spawn cmd
    where cmd = "xdotool mousemove_relative -- " ++ (unwords $ show <$> [x,y])





-- Revisa en el estado si las barras están visibles o no para ocultarlas o mostrarlas. 
-- modifica el estado respectivamente
toggleBars :: X ()
toggleBars = do
    st <- XS.get -- :: X MyState
    if showBars st 
        then broadcastMessage $ SetStruts [] [minBound .. maxBound]
        else broadcastMessage $ SetStruts [minBound .. maxBound] []
    XS.modify toggleShowBars
    refresh


-- Modifica el estado para invertir el valor que dice si hay que mostrar las barras
-- https://stackoverflow.com/questions/14955627/shorthand-way-for-modifying-only-one-field-in-a-record-copy-a-record-changing#14955676
toggleShowBars :: MyState -> MyState
toggleShowBars st = st {showBars = not $ showBars st}


-------------------------------------------------------------------------------------------------------------------
--                        S t a t e f u l    c o n f i g 
-------------------------------------------------------------------------------------------------------------------
data MyState = GK {showBars :: Bool, keyboardMouse :: Bool}
instance ExtensionClass MyState where
    initialValue = GK { showBars = True
                      , keyboardMouse = False} 


