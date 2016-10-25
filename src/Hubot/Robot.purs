module Hubot.Robot (
  hear
  , respond
  ) where

import Prelude

import Data.Function.Uncurried (Fn3, runFn3)

import Hubot (RobotEff, Robot, ResponseHandler)


-- | Defines a "hear" handler for the provided Robot.
hear :: forall e. String -> ResponseHandler e -> Robot -> RobotEff e Unit
hear pattern handler robot = runFn3 _hear pattern handler robot

foreign import _hear :: forall e. Fn3
  String
  (ResponseHandler e)
  Robot
  (RobotEff e Unit)

respond :: forall e. String -> ResponseHandler e -> Robot -> RobotEff e Unit
respond pattern handler robot = runFn3 _respond pattern handler robot

foreign import _respond :: forall e. Fn3
  String
  (ResponseHandler e)
  Robot
  (RobotEff e Unit)
