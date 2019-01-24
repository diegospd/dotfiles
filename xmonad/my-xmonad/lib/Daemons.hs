{-# LANGUAGE OverloadedStrings #-}

module Daemons (wake_daemons) where

import Bash
import Data.Text(Text)
import Turtle


daemons :: [Daemon]
daemons =
  [ Daemon "unclutter" []
  , Daemon "kb" []
  , Daemon "espeak" ["Summoning all lambda demons"]
  ]



data Daemon = Daemon {
    command :: Text,
    args :: [Text]
}


start_daemon :: MonadIO io => Daemon -> io ()
start_daemon daemon = do
    kill_if_running $ command daemon
    sh $ procStrict (command daemon) (args daemon) ""

    
wake_daemons :: MonadIO io => io ()
wake_daemons = mapM_ start_daemon daemons
