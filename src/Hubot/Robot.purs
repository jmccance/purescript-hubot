module Hubot.Robot (
  RobotConfig()
  , RobotConfigM()
  , withRobot
  , hear
  ) where

import Prelude
import Control.Monad.Eff (Eff)
import Data.Function.Uncurried (Fn3, runFn3)
import Hubot (ROBOT, Robot, RESPONSE, Response)
import Hubot.Response (ResponseEff)

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

-- | Initialize a Hubot instance with your handlers.
withRobot :: forall e a. RobotConfigM e a -> Robot -> Eff e a
withRobot (RobotConfigM f) = f

-- | Define a "hear" handler for Hubot.
hear :: forall e.
  String
  -> (Response -> ResponseEff e Unit)
  -> RobotConfig e
hear pattern handler = RobotConfigM \robot ->
  runFn3 _hear pattern handler robot

foreign import _hear :: forall e. Fn3
  String
  (Response -> Eff (response :: RESPONSE | e) Unit)
  Robot
  (Eff (robot :: ROBOT | e) Unit)
