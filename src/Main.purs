module Main (main) where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (log)
import Control.Monad.Eff.Unsafe (unsafePerformEff)

import Hubot.Robot (ROBOT, Robot, withRobot, hear)

main :: forall e. Robot -> Eff (robot :: ROBOT | e) Unit
main = withRobot do
  hear "aaa" (\_ -> unsafePerformEff $ log "Heard asdf")
