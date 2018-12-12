 {-# LANGUAGE OverloadedStrings #-}
module Bash (
    is_installed, is_running,
    kill_if_running,
    x_compile, x_start, x_restart, x_is_running, xmonad_bin,
    x_kill_if_running, x_kill_children,
    say, fix_keyboard ) where

import Turtle
import Prelude hiding(FilePath)
import Data.Maybe


-- | Returns IO True iff 'program' is an executable in PATH
is_installed :: MonadIO m => Turtle.FilePath -> m Bool
is_installed program = which program >>= return . isJust


-- | Says what
say :: MonadIO io => Text -> io ()
say what = proc "espeak" [what] "" >> return () 

stack :: Text -> Text
stack command = "stack --system-ghc " <> command

xmonad' :: Text -> Text
xmonad' mode = stack "exec xmonad -- --" <> mode

xmonad :: MonadIO io => Text -> io ()
xmonad mode = shell (xmonad' mode) ""  >> return ()

x_compile :: MonadIO io => io ()
x_compile = xmonad "recompile"

x_start :: MonadIO io => io ()
x_start = proc xmonad_bin ["--replace"] ""  >> return ()

x_restart :: MonadIO io => io ()
x_restart = do
    x_kill_children
    _ <- x_kill_if_running
    x_start
    return ()

x_is_running ::  MonadIO io => io Bool
x_is_running = is_running xmonad_bin

x_kill_if_running :: MonadIO io => io Bool
x_kill_if_running = kill_if_running xmonad_bin

x_kill_children :: MonadIO io => io ()
x_kill_children = mapM_ kill_if_running ["dzen2", "conky"]

kill_if_running :: MonadIO io => Text -> io (Bool)
kill_if_running program = do
    can_kill <- is_running program
    if can_kill
        then proc "killall" [program] "" >> return can_kill
        else return can_kill



fix_keyboard :: MonadIO io => io ExitCode
fix_keyboard = proc "kb" [] ""

is_running :: MonadIO io => Text -> io Bool
is_running program = do
    exitCode <- proc "pidof" [program] ""
    return $ case exitCode of
        ExitSuccess -> True
        ExitFailure{} -> False

xmonad_bin :: Text
xmonad_bin = "xmonad-x86_64-linux"

