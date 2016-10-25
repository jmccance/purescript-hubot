module Hubot.Robot (
    catchAll
  , enter
  , error
  , hear
  , leave
  , respond
  , topic
  ) where

import Prelude
import Data.Function.Uncurried (runFn2, Fn2, Fn3, runFn3)
import Hubot (RobotEff, Robot, ResponseHandler)

catchAll :: forall e. ResponseHandler e -> Robot -> RobotEff e Unit
catchAll handler robot = runFn2 _catchAll handler robot

foreign import _catchAll :: forall e. Fn2
  (ResponseHandler e)
  Robot
  (RobotEff e Unit)

enter :: forall e. ResponseHandler e -> Robot -> RobotEff e Unit
enter handler robot = runFn2 _enter handler robot

foreign import _enter :: forall e. Fn2
  (ResponseHandler e)
  Robot
  (RobotEff e Unit)

error :: forall e. ResponseHandler e -> Robot -> RobotEff e Unit
error handler robot = runFn2 _error handler robot

foreign import _error :: forall e. Fn2
  (ResponseHandler e)
  Robot
  (RobotEff e Unit)

hear :: forall e. String -> ResponseHandler e -> Robot -> RobotEff e Unit
hear pattern handler robot = runFn3 _hear pattern handler robot

foreign import _hear :: forall e. Fn3
  String
  (ResponseHandler e)
  Robot
  (RobotEff e Unit)

leave :: forall e. ResponseHandler e -> Robot -> RobotEff e Unit
leave handler robot = runFn2 _leave handler robot

foreign import _leave :: forall e. Fn2
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

topic :: forall e. ResponseHandler e -> Robot -> RobotEff e Unit
topic handler robot = runFn2 _topic handler robot

foreign import _topic :: forall e. Fn2
  (ResponseHandler e)
  Robot
  (RobotEff e Unit)
