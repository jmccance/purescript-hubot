module Hubot.Robot (
  ROBOT
  , Message
  , Robot
  , RobotConfig()
  , RobotConfigM()
  , withRobot
  , hear
  , listen
  ) where

import Prelude
import Control.Monad.Eff (Eff)

-- | The `ROBOT` effect indicates that an Eff action may access or modify a Hubot RobotConfig.
foreign import data ROBOT :: !

foreign import data Message :: *
foreign import data Robot :: *

-- BEGIN CARGO CULTING
-- https://github.com/dancingrobot84/purescript-express/blob/0.4.0/src/Node/Express/App.purs#L27
data RobotConfigM e a = RobotConfigM (Robot -> Eff e a)
type RobotConfig e = RobotConfigM (robot :: ROBOT | e) Unit

instance functorRobotConfigM :: Functor (RobotConfigM e) where
  map f (RobotConfigM h) = RobotConfigM \r -> liftM1 f $ h r

instance applyRobotConfigM :: Apply (RobotConfigM e) where
  apply (RobotConfigM f) (RobotConfigM h) = RobotConfigM \robot -> do
    res <- h robot
    trans <- f robot
    pure $ trans res

instance applicativeRobotConfigM :: Applicative (RobotConfigM e) where
  pure x = RobotConfigM \_ -> pure x

instance bindRobotConfigM :: Bind (RobotConfigM e) where
  bind (RobotConfigM h) f = RobotConfigM \robot -> do
    res <- h robot
    case f res of
      RobotConfigM g -> g robot
--END CARGO CULTING (mostly)

--| Initialize a Hubot instance with your handlers.
withRobot :: forall e a. RobotConfigM e a -> Robot -> Eff e a
withRobot (RobotConfigM f) = f

--| Define a "hear" handler for Hubot.
hear :: forall e a.
  String
  -> (Message -> a)
  -> RobotConfig e
hear pattern handler = RobotConfigM \robot ->
  _hear pattern handler robot

--| Define a "listen" handler for Hubot.
listen :: forall e a.
  (Message -> Boolean)
  -> (Message -> a)
  -> RobotConfig e
listen matcher handler = RobotConfigM \robot ->
  _listen matcher handler robot

--| Define a "respond" handler for Hubot.
respond :: forall e a.
  String
  -> (Message -> a)
  -> RobotConfig e
respond pattern handler = RobotConfigM \robot ->
  _respond pattern handler robot

foreign import _hear :: forall e a.
  String
  -> (Message -> a)
  -> Robot
  -> (Eff (robot :: ROBOT | e) Unit)

foreign import _listen :: forall e a.
  (Message -> Boolean)
  -> (Message -> a)
  -> Robot
  -> (Eff (robot :: ROBOT | e) Unit)

foreign import _respond :: forall e a.
  String
  -> (Message -> a)
  -> Robot
  -> (Eff (robot :: ROBOT | e) Unit)
