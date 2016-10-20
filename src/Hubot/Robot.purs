module Hubot.Robot (
  ROBOT
  , RobotM()
  , Robot()
  , Message
  , hear
  , listen
  , withRobot
  , Robot'
  ) where

import Prelude
import Control.Monad.Eff (Eff)

-- | The `ROBOT` effect indicates that an Eff action may access or modify a Hubot Robot.
foreign import data ROBOT :: !

foreign import data Message :: *
foreign import data Robot' :: *

-- BEGIN CARGO CULTING
-- https://github.com/dancingrobot84/purescript-express/blob/0.4.0/src/Node/Express/App.purs#L27
data RobotM e a = RobotM (Robot' -> Eff e a)
type Robot e = RobotM (robot :: ROBOT | e) Unit

instance functorRobotM :: Functor (RobotM e) where
  map f (RobotM h) = RobotM \r -> liftM1 f $ h r

instance applyRobotM :: Apply (RobotM e) where
  apply (RobotM f) (RobotM h) = RobotM \robot -> do
    res <- h robot
    trans <- f robot
    pure $ trans res

instance applicativeRobotM :: Applicative (RobotM e) where
  pure x = RobotM \_ -> pure x

instance bindRobotM :: Bind (RobotM e) where
  bind (RobotM h) f = RobotM \robot -> do
    res <- h robot
    case f res of
      RobotM g -> g robot
--END CARGO CULTING (mostly)

--| Initialize a Hubot instance with your handlers.
withRobot :: forall e a. RobotM e a -> Robot' -> Eff e a
withRobot (RobotM f) = f

--| Define a "hear" handler for Hubot.
hear :: forall e a.
  String
  -> (Message -> a)
  -> Robot e
hear pattern handler = RobotM \robot ->
  _hear pattern handler robot

--| Define a "listen" handler for Hubot.
listen :: forall e a.
  (Message -> Boolean)
  -> (Message -> a)
  -> Robot e
listen matcher handler = RobotM \robot ->
  _listen matcher handler robot

--| Define a "respond" handler for Hubot.
respond :: forall e a.
  String
  -> (Message -> a)
  -> Robot e
respond pattern handler = RobotM \robot ->
  _respond pattern handler robot

foreign import _hear :: forall e a.
  String
  -> (Message -> a)
  -> Robot'
  -> (Eff (robot :: ROBOT | e) Unit)

foreign import _listen :: forall e a.
  (Message -> Boolean)
  -> (Message -> a)
  -> Robot'
  -> (Eff (robot :: ROBOT | e) Unit)

foreign import _respond :: forall e a.
  String
  -> (Message -> a)
  -> Robot'
  -> (Eff (robot :: ROBOT | e) Unit)
