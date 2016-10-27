module Hubot.Robot (
    catchAll
  , enter
  , hear
  , leave
  , respond
  , topic
  ) where

import Prelude
import Control.Monad.Except (runExcept)
import Data.Either (either)
import Data.Foreign (toForeign)
import Data.Foreign.Class (class IsForeign, read)
import Data.Function.Uncurried (runFn2, Fn2, Fn3, runFn3)
import Hubot (ResponseEff, Response, TopicMessage, LeaveMessage, TextMessage, CatchAllMessage, RobotEff, Robot, MessageHandler, EnterMessage)
import Hubot.Response (send)

type ResponseHandler e = Response -> ResponseEff e Unit

-- | Convert a MessageHandler to a ResponseHandler by extracting the message
-- | from the response and applying the MessageHandler to it.
-- | If the message cannot be extracted, send an error message to the room.
handleResponse :: forall m e. IsForeign m =>
  MessageHandler m e -> ResponseHandler e
handleResponse handler response = handleOrLogError errorOrMessage response
  where
    errorOrMessage = runExcept $ read $ toForeign response
    handleOrLogError =
      either
        (show >>> (append "ERROR: ") >>> send)
        handler

catchAll :: forall e. MessageHandler CatchAllMessage e -> Robot -> RobotEff e Unit
catchAll msgHandler robot = runFn2 _catchAll (handleResponse msgHandler) robot

foreign import _catchAll :: forall e. Fn2
  (ResponseHandler e)
  Robot
  (RobotEff e Unit)

enter :: forall e. MessageHandler EnterMessage e -> Robot -> RobotEff e Unit
enter msgHandler robot = runFn2 _enter (handleResponse msgHandler) robot

foreign import _enter :: forall e. Fn2
  (ResponseHandler e)
  Robot
  (RobotEff e Unit)

hear :: forall e.
     String
  -> MessageHandler TextMessage e
  -> Robot
  -> RobotEff e Unit
hear pattern handler robot = runFn3 _hear pattern (handleResponse handler) robot

foreign import _hear :: forall e. Fn3
  String
  (ResponseHandler e)
  Robot
  (RobotEff e Unit)

leave :: forall e. MessageHandler LeaveMessage e -> Robot -> RobotEff e Unit
leave msgHandler robot = runFn2 _leave (handleResponse msgHandler) robot

foreign import _leave :: forall e. Fn2
  (ResponseHandler e)
  Robot
  (RobotEff e Unit)

respond :: forall e.
     String
  -> MessageHandler TextMessage e
  -> Robot
  -> RobotEff e Unit
respond pattern msgHandler robot =
  runFn3 _respond pattern (handleResponse msgHandler) robot

foreign import _respond :: forall e. Fn3
  String
  (ResponseHandler e)
  Robot
  (RobotEff e Unit)

topic :: forall e. MessageHandler TopicMessage e -> Robot -> RobotEff e Unit
topic msgHandler robot = runFn2 _topic (handleResponse msgHandler) robot

foreign import _topic :: forall e. Fn2
  (ResponseHandler e)
  Robot
  (RobotEff e Unit)
