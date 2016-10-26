module Hubot.Robot where

import Prelude
import Data.Function.Uncurried (runFn2, Fn2, Fn3, runFn3)
import Hubot (TopicMessage, LeaveMessage, TextMessage, CatchAllMessage, RobotEff, Robot, MessageHandler, EnterMessage)

-- x :: forall m e. MessageHandler m -> Response -> ResponseEff e Unit
-- x handler r =
--   r

catchAll :: forall e. MessageHandler CatchAllMessage e -> Robot -> RobotEff e Unit
catchAll handler robot = runFn2 _catchAll handler robot

foreign import _catchAll :: forall e. Fn2
  (MessageHandler CatchAllMessage e)
  Robot
  (RobotEff e Unit)

enter :: forall e. MessageHandler EnterMessage e -> Robot -> RobotEff e Unit
enter handler robot = runFn2 _enter handler robot

foreign import _enter :: forall e. Fn2
  (MessageHandler EnterMessage e)
  Robot
  (RobotEff e Unit)

hear :: forall e. String -> MessageHandler TextMessage e -> Robot -> RobotEff e Unit
hear pattern handler robot = runFn3 _hear pattern handler robot

foreign import _hear :: forall e. Fn3
  String
  (MessageHandler TextMessage e)
  Robot
  (RobotEff e Unit)

leave :: forall e. MessageHandler LeaveMessage e -> Robot -> RobotEff e Unit
leave handler robot = runFn2 _leave handler robot

foreign import _leave :: forall e. Fn2
  (MessageHandler LeaveMessage e)
  Robot
  (RobotEff e Unit)

respond :: forall e. String -> MessageHandler TextMessage e -> Robot -> RobotEff e Unit
respond pattern handler robot = runFn3 _respond pattern handler robot

foreign import _respond :: forall e. Fn3
  String
  (MessageHandler TextMessage e)
  Robot
  (RobotEff e Unit)

topic :: forall e. MessageHandler TopicMessage e -> Robot -> RobotEff e Unit
topic handler robot = runFn2 _topic handler robot

foreign import _topic :: forall e. Fn2
  (MessageHandler TopicMessage e)
  Robot
  (RobotEff e Unit)
