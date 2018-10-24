 {-# LANGUAGE OverloadedStrings #-}

module Keys (myKeys, theKeys, forbiddenKeys, myMod) where

import XMonad
import XMonad.Util.EZConfig

import Bash
import Data.Text hiding(concat, unwords, intersperse,zip)
import Prelude hiding (sequence)
import Data.List

import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W -- to shift and float windows
import qualified XMonad.Util.ExtensibleState as XS


myMod :: KeyMask
myMod = mod4Mask

type KeyBinding = (String, X())

theKeys :: [KeyBinding]
theKeys = admin
       ++ multimedia 
       ++ launchers   
       ++ mouseKeys 
       ++ dolphin
       ++ konsole

forbiddenKeys :: [String]
-- Plasma uses this sequence to trigger its own workspace
-- switcher. 
-- TODO Fix this
forbiddenKeys = ["M-q"]
-- TODO switch to emacs
myKeys = numpadSwitcher

   
-- Emacs style key sequecences
-- https://hackage.haskell.org/package/xmonad-contrib-0.13/docs/XMonad-Util-EZConfig.html
launchers :: [KeyBinding]
launchers = 
    [
      ("M-/", spawn "chromium")
    , ("M-S-/", spawn "google-chrome-stable")
    , ("M-m", spawn "ksysguard")
    , ("M-v", spawn "keepassx")
    , ("M-k", spawn "ktorrent")
    , ("M-x x", openSubl "~/.dotfiles/xmonad/xmonad.hs")
    , ("M-x k", openSubl "~/.dotfiles/xmonad/Keys.hs")
    , ("M-x i", openSubl "~/.dotfiles/xmonad/InfoBars.hs")
    , ("M-x z", openSubl "~/.zshrc")
    , ("M-x .", openSubl "~/.dotfiles")
    , ("M-x p", openSubl "~/storage/codigos/haskell/pol")
    , ("M-S-<KP_Enter>", spawn "konsole -e ~/.local/bin/pol")
    , ("M-S-<KP_Subtract>", spawn "echo \"cd ~/storage/crypto/tor-browser_en-US && ./start-tor-browser.desktop\" | bash")
    ]

openSubl :: String -> X ()
openSubl path = spawn $ "subl3 --new-window " <> path

multimedia :: [KeyBinding]
multimedia =  
    [
      ("M-<KP_Add>", spawn $ spotify "PlayPause")
    , ("M-<KP_Multiply>", spawn $ spotify "Previous")
    , ("M-<KP_Subtract>", spawn $ spotify "Next")
    ] where spotify = ("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player." ++)


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

runDolphin :: String -> X()
runDolphin path = spawn $ "dolphin " <> path

konsole :: [KeyBinding] 
konsole =
    [
      ("M-\\ s", spawn "konsole --workdir ~/shelf")
    , ("M-\\ d", spawn "konsole --workdir ~/Dropbox")
    , ("M-\\ v", spawn "konsole --workdir ~/shelf/video/")
    , ("M-\\ x", spawn "konsole --workdir ~/.dotfiles/xmonad/")
    ] 



admin :: [KeyBinding]
admin =
    [
      ("M-p", run_rofi)
    , ("M-b", toggleBars)
    , ("M-a p", run_rofi)
    -- , ("M-a <Backspace>", restart_xmonad)
    , ("M-a <Backspace>", x_restart)
    , ("M-a =", x_compile)
    , ("M-a a", say "All systems are okay")
    , ("M-a b", restart_pulseaudio)
    , ("M-a s", spawn "systemsettings5")
    ]




-- We are building everything with stack.
xmonad_command :: String -> BashCommand
xmonad_command flags = pad_cmd $ "stack --system-ghc exec xmonad -- " <> flags  
recompile_command = xmonad_command "--recompile "
restart_command   = xmonad_command "--restart "
replace_command   = xmonad_command "--replace "

pad_cmd :: String -> BashCommand
pad_cmd c = " " <> c <> " "

sequence :: [String] -> BashCommand
sequence xs = pad_cmd $ concat $ intersperse " && " (pad_cmd <$> xs) 

type BashCommand = String 

if_xmonad_is_running :: BashCommand -> BashCommand -> BashCommand
if_xmonad_is_running when_true when_false = pad_cmd $ concat xs
    where xs = ["if type xmonad; then ", when_true, " ; else ", when_false, " ; fi"]

restart_pulseaudio = spawn "pulseaudio -k || pulseaudio --start"
-- recompile_xmonad = spawn $ if_xmonad_is_running (
--                               sequence [
--                                 "killall dzen2"
--                                 ,recompile_command
--                                 ,restart_command  ] )
--                               " xmessage xmonad not in \\$PATH: \"$PATH\" "
-- recompile_xmonad = spawn $ if_xmonad_is_running ("killall dzen2 && " ++ recompile_command ++ " && xmonad --restart") "xmessage xmonad not in \\$PATH: \"$PATH\""
-- restart_xmonad = spawn "if type xmonad; then killall dzen2 && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi" 
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


