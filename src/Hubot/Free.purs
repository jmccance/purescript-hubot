module Hubot.Free (
    ResponseF
  , RobotF
  , catchAll
  , emote
  , enter
  , error
  , getMatch
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

import Control.Monad.Free (Free, foldFree, liftF)

import Hubot as Hubot
import Hubot.Response as HResponse
import Hubot.Robot as HRobot

data ResponseF a
  = Emote String a
  | Reply String a
  | Send String a
  | GetMatch (Array String -> a)
  | SetTopic String a

type Response = Free ResponseF

emote :: String -> Response Unit
emote emotion = liftF (Emote emotion unit)

getMatch :: Response (Array String)
getMatch = liftF (GetMatch id)

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
evalResponse r (GetMatch f)       = f           <$> HResponse.getMatch r
evalResponse r (Reply m next)     = const next  <$> HResponse.reply m r
evalResponse r (Send m next)      = const next  <$> HResponse.send m r
evalResponse r (SetTopic t next)  = const next  <$> HResponse.setTopic t r

---

data RobotF e a next
  = CatchAll        (Response a) next
  | Enter           (Response a) next
  | Error           (Response a) next
  | Hear    String  (Response a) next
  | Leave           (Response a) next
  | Respond String  (Response a) next
  | Topic           (Response a) next

type Robot e a = Free (RobotF e a)

catchAll :: forall e a. Response a -> Robot e a Unit
catchAll handler = liftF (CatchAll handler unit)

enter :: forall e a. Response a -> Robot e a Unit
enter handler = liftF (Enter handler unit)

error :: forall e a. Response a -> Robot e a Unit
error handler = liftF (Error handler unit)

hear :: forall e a.
     String
  -> Response a
  -> Robot e a Unit
hear pattern handler = liftF (Hear pattern handler unit)

leave :: forall e a. Response a -> Robot e a Unit
leave handler = liftF (Leave handler unit)

respond :: forall e a.
     String
  -> Response a
  -> Robot e a Unit
respond pattern handler = liftF (Respond pattern handler unit)

topic :: forall e a. Response a -> Robot e a Unit
topic handler = liftF (Topic handler unit)

-- | Given an expression in the Robot DSL, product a function that will apply that expression to an
-- | actual Hubot Robot. In other words, this will almost always be the first function in your
-- | script's main function.
robot :: forall e a.
     Robot e Unit a
  -> Hubot.Robot
  -> Hubot.RobotEff e a
robot r hr = foldFree (evalRobot hr) r

evalRobot :: forall e.
     Hubot.Robot
  -> RobotF e Unit ~> Hubot.RobotEff e
evalRobot r (CatchAll resp next)  = const next <$> HRobot.catchAll (handle resp) r
evalRobot r (Enter resp next)     = const next <$> HRobot.enter (handle resp) r
evalRobot r (Error resp next)     = const next <$> HRobot.error (handle resp) r
evalRobot r (Hear p resp next)    = const next <$> HRobot.hear p (handle resp) r
evalRobot r (Leave resp next)     = const next <$> HRobot.leave (handle resp) r
evalRobot r (Respond p resp next) = const next <$> HRobot.respond p (handle resp) r
evalRobot r (Topic resp next)     = const next <$> HRobot.topic (handle resp) r
