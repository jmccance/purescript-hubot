module Hubot.Free (
  ResponseF
  , RobotF
  , getMatch
  , handle
  , send
  , reply
  , hear
  , respond
  , robot
  ) where

import Prelude
import Hubot as Hubot
import Hubot.Response as HResponse
import Hubot.Robot as HRobot
import Control.Monad.Free (Free, foldFree, liftF)

data ResponseF a
  = Send String a
  | Reply String a
  | GetMatch (Array String -> a)

type Response = Free ResponseF

send :: String -> Response Unit
send message = liftF (Send message unit)

reply :: String -> Response Unit
reply message = liftF (Reply message unit)

getMatch :: Response (Array String)
getMatch = liftF (GetMatch id)

handle :: forall e a.
     Response a
  -> Hubot.Response
  -> Hubot.ResponseEff e a
handle ra hr = foldFree (evalResponse hr) ra

evalResponse :: forall e. Hubot.Response -> ResponseF ~> Hubot.ResponseEff e
evalResponse r (Send m next)  = const next <$> HResponse.send m r
evalResponse r (Reply m next) = const next <$> HResponse.reply m r
evalResponse r (GetMatch f)   = f <$> HResponse.getMatch r

---

data RobotF e a next
  = Hear String (Response a) next
  | Respond String (Response a) next

type Robot e a = Free (RobotF e a)

hear :: forall e a.
     String
  -> Response a
  -> Robot e a Unit
hear pattern handler = liftF (Hear pattern handler unit)

respond :: forall e a.
     String
  -> Response a
  -> Robot e a Unit
respond pattern handler = liftF (Respond pattern handler unit)

robot :: forall e a.
     Robot e Unit a
  -> Hubot.Robot
  -> Hubot.RobotEff e a
robot r hr = foldFree (evalRobot hr) r

evalRobot :: forall e. Hubot.Robot -> RobotF e Unit ~> Hubot.RobotEff e
evalRobot r (Hear p resp next) =
  const next <$> HRobot.hear p (handle resp) r
evalRobot r (Respond p resp next) =
  const next <$> HRobot.respond p (handle resp) r
