 {-# LANGUAGE OverloadedStrings #-}
module Bash (
    say,
    is_installed,
    xmonad_recompile, xmonad_start, xmonad_restart,
    fix_keyboard ) where

import Turtle
import Prelude hiding(FilePath)
import Data.Maybe
import Data.Text
import Data.Either

-- | Returns IO True iff 'program' is an executable in PATH
is_installed :: MonadIO m => Turtle.FilePath -> m Bool
is_installed program = which program >>= return . isJust


-- | Says what
say :: MonadIO io => Text -> io ExitCode
say what = proc "espeak" [what] "" 

stack :: Text -> Text
stack command = "stack --system-ghc " <> command

xmonad' :: Text -> Text
xmonad' mode = stack "exec xmonad -- --" <> mode

xmonad :: MonadIO io => Text -> io ExitCode
xmonad mode = shell (xmonad' mode) ""

xmonad_recompile :: MonadIO io => io ExitCode
xmonad_recompile = xmonad "recompile"

xmonad_start :: MonadIO io => io ExitCode
xmonad_start = xmonad "replace"

xmonad_restart :: MonadIO io => io ExitCode
xmonad_restart = xmonad "restart"

fix_keyboard :: MonadIO io => io ExitCode
fix_keyboard = proc "kb" [] ""

is_running program = do
    executable <- foo <$> which program
    return $ grep executable ps_fea

-- if [[ $(ps -ef | grep -c xmonad)  -ne 1 ]]; then say simon; else say changos ; fi
-- is_running program = 
--     where 
--           pattern = foo <$> which program

foo :: Maybe FilePath -> Pattern Text
foo = text . (fromRight "???") . toText . fromJust

ps_fea :: Shell Line
ps_fea = inproc "ps" ["-fea"] ""