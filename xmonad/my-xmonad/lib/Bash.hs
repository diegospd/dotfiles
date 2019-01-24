 {-# LANGUAGE OverloadedStrings #-}
module Bash (
    is_installed, is_running,
    kill_if_running,
    say ) where

import Turtle
import Prelude hiding(FilePath)
import Data.Maybe


-- | Returns IO True iff 'program' is an executable in PATH
is_installed :: MonadIO m => Turtle.FilePath -> m Bool
is_installed program = which program >>= return . isJust


-- | Says what
say :: MonadIO io => Text -> io ()
say what = proc "espeak" [what] "" >> return () 


kill_if_running :: MonadIO io => Text -> io Bool
kill_if_running program = do
    can_kill <- is_running program
    if can_kill
        then proc "killall" [program] "" >> return can_kill
        else return can_kill


is_running :: MonadIO io => Text -> io Bool
is_running program = do
    exitCode <- proc "pidof" [program] ""
    return $ case exitCode of
        ExitSuccess -> True
        ExitFailure{} -> False

xmonad_bin :: Text
xmonad_bin = "xmonad-x86_64-linux"

