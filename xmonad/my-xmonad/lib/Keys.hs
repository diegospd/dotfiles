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

run = spawn

theKeys :: [KeyBinding]
theKeys = admin
       ++ stateful
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
      ("M-/", run chromium)
    , ("M-S-/", run chrome)
    , ("M-m", run "ksysguard")
    , ("M-v", run "keepassxc")
    , ("M-S-v", run "keepassx")
    , ("M-x x", run $ sublime "")
    , ("M-x k", run $ sublime "~/.dotfiles/xmonad/Keys.hs")
    , ("M-x i", run $ sublime "~/.dotfiles/xmonad/InfoBars.hs")
    , ("M-x z", run $ sublime "~/.zshrc")
    , ("M-x .", run $ sublime "~/.dotfiles")
    , ("M-x p", run $ sublime "~/storage/codigos/haskell/pol")
    , ("M-S-<KP_Enter>", run "konsole -e ~/.local/bin/pol")
    , ("M-S-<KP_Subtract>", run "echo \"cd ~/storage/crypto/tor-browser_en-US && ./start-tor-browser.desktop\" | bash")
    , ("M-i", run "flameshot gui")
    ]


multimedia :: [KeyBinding]
multimedia =  
    [
      ("M-<KP_Add>", run $ spotify_dbus "PlayPause")
    , ("M-<KP_Multiply>", run $ spotify_dbus "Previous")
    , ("M-<KP_Subtract>", run $ spotify_dbus "Next")
    ]


launch_and_play :: X ()
launch_and_play = do
    !running <- is_running "spotify"
    !check <- when (not running) $ do
        run "spotify"
        sleep 5.0
    !go <- run $ spotify_dbus "PlayPause"
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
      ("M-\\ s", run $ cmd "~/shelf")
    , ("M-\\ d", run $ cmd "~/Dropbox")
    , ("M-\\ v", run $ cmd "~/shelf/video/")
    , ("M-\\ x", run $ cmd "~/.dotfiles/xmonad/")
    ]
    where cmd = (<>) "konsole --profile dieg --workdir "

stateful :: [KeyBinding]
stateful = [("M-b",   toggleBars)]

admin :: [KeyBinding]
admin =
    [
      ("M-p",   run rofi)
    , ("M-o",   run rofi)
    , ("M-a p", run rofi)
    , ("M-a <Backspace>", run xmonad_restart)
    , ("M-a =", run "xmonad-x86_64-linux --recompile && xmonad-x86_64-linux --restart")
    , ("M-a b", run restart_pulseaudio)
    , ("M-a s", run "systemsettings5")
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

sublime :: String -> Command
sublime path = "subl3 --new-window " <> path

spotify_dbus :: String -> Command
spotify_dbus = (++) "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player."

rofi :: Command
rofi = unwords
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

runDolphin' :: String -> Command
runDolphin' path = "dolphin " <> path
runDolphin = run . runDolphin'

xmonad_restart :: Command
xmonad_restart = "xmonad-x86_64-linux --restart"
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
    , ("M-M1-<KP_Insert>", run "xdotool click 1")
    , ("M-M1-C-<KP_Insert>", run "xdotool click 3")
    -- , ("M-C-<Up>", run "xdotool click 4")
    -- , ("M-C-<Down>", run "xdotool click 5")
    -- , ("M-C-<Left>", run "xdotool click Left")
    -- , ("M-C-<Right>", run "xdotool click Right")
    ]
moveMouse :: Int -> Int -> X ()
moveMouse x y = run cmd
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


