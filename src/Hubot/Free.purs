module Hubot.Free (
    Response
  , ResponseF
  , RobotF
  , catchAll
  , emote
  , enter
  , noAction
  , handle
  , hear
  , leave
  , reply
  , respond
  , robot
  , send
  , setTopic
  , topic
  ) where

import Prelude
import Hubot as Hubot
import Hubot.Response as HResponse
import Hubot.Robot as HRobot
import Control.Monad.Free (Free, foldFree, liftF)
import Hubot (EnterMessage, CatchAllMessage, TopicMessage, LeaveMessage, TextMessage)

data ResponseF a
  = Emote String a
  | Reply String a
  | Send String a
  | SetTopic String a
  | NoAction a

type Response = Free ResponseF

emote :: String -> Response Unit
emote emotion = liftF (Emote emotion unit)

noAction :: Response Unit
noAction = liftF (NoAction unit)

reply :: String -> Response Unit
reply message = liftF (Reply message unit)

send :: String -> Response Unit
send message = liftF (Send message unit)

setTopic :: String -> Response Unit
setTopic newTopic = liftF (SetTopic newTopic unit)

handle :: forall e a.
     Response a
  -> Hubot.Response
  -> Hubot.ResponseEff e a
handle ra hr = foldFree (evalResponse hr) ra

evalResponse :: forall e.
     Hubot.Response
  -> ResponseF ~> Hubot.ResponseEff e
evalResponse r (Emote e next)     = const next  <$> HResponse.emote e r
evalResponse r (NoAction next)    = const next  <$> pure unit
evalResponse r (Reply m next)     = const next  <$> HResponse.reply m r
evalResponse r (Send m next)      = const next  <$> HResponse.send m r
evalResponse r (SetTopic t next)  = const next  <$> HResponse.setTopic t r

---

type Handler m a = m -> Response a

data RobotF e a next
  = CatchAll        (Handler CatchAllMessage a) next
  | Enter           (Handler EnterMessage a) next
  | Hear    String  (Handler TextMessage a) next
  | Leave           (Handler LeaveMessage a) next
  | Respond String  (Handler TextMessage a) next
  | Topic           (Handler TopicMessage a) next

type Robot e a = Free (RobotF e a)

catchAll :: forall e a. Handler CatchAllMessage a -> Robot e a Unit
catchAll handler = liftF (CatchAll handler unit)

enter :: forall e a. Handler EnterMessage a -> Robot e a Unit
enter handler = liftF (Enter handler unit)

hear :: forall e a.
     String
  -> Handler TextMessage a
  -> Robot e a Unit
hear pattern handler = liftF (Hear pattern handler unit)

leave :: forall e a. Handler LeaveMessage a -> Robot e a Unit
leave handler = liftF (Leave handler unit)

respond :: forall e a.
     String
  -> Handler TextMessage a
  -> Robot e a Unit
respond pattern handler = liftF (Respond pattern handler unit)

topic :: forall e a. Handler TopicMessage a -> Robot e a Unit
topic handler = liftF (Topic handler unit)

-- | Given an expression in the Robot DSL, product a function that will apply
-- | that expression to an actual Hubot Robot. In other words, this will almost
-- | always be the first function in your script's main function.
robot :: forall e a.
     Robot e Unit a
  -> Hubot.Robot
  -> Hubot.RobotEff e a
robot r hr = foldFree (evalRobot hr) r

evalRobot :: forall e.
     Hubot.Robot
  -> RobotF e Unit ~> Hubot.RobotEff e
evalRobot r (CatchAll resp next)  = const next <$> HRobot.catchAll (resp >>> handle) r
evalRobot r (Enter resp next)     = const next <$> HRobot.enter (resp >>> handle) r
evalRobot r (Hear p resp next)    = const next <$> HRobot.hear p (resp >>> handle) r
evalRobot r (Leave resp next)     = const next <$> HRobot.leave (resp >>> handle) r
evalRobot r (Respond p resp next) = const next <$> HRobot.respond p (resp >>> handle) r
evalRobot r (Topic resp next)     = const next <$> HRobot.topic (resp >>> handle) r
