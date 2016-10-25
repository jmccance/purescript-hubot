module Hubot.Free (
  ResponseF
  , ResponseT
  , handle
  , send
  , reply
  , runResponse
  , runResponseT
  ) where

import Prelude
import Hubot as Hubot
import Hubot.Response as HResponse
import Control.Monad.Eff (Eff)
import Control.Monad.Free.Trans (hoistFreeT, runFreeT, liftFreeT, FreeT)
import Data.Coyoneda (hoistCoyoneda, lowerCoyoneda, liftCoyoneda, Coyoneda)
import Data.Identity (Identity(..))

data ResponseF a
  = Send String a
  | Reply String a

type ResponseT m = FreeT (Coyoneda ResponseF) m

type Response = ResponseT Identity

liftResponse :: forall m a. Monad m => ResponseF a -> ResponseT m a
liftResponse = liftFreeT <<< liftCoyoneda

send :: forall m. Monad m => String -> ResponseT m Unit
send message = liftResponse $ Send message unit

reply :: forall m. Monad m => String -> ResponseT m Unit
reply message = liftResponse $ Reply message unit

runResponse :: forall e a.
     Hubot.Response
  -> Response a
  -> Hubot.ResponseEff e a
runResponse r =
  runFreeT (lowerCoyoneda <<< hoistCoyoneda (interp r))
    <<< hoistFreeT (pure <<< (\ (Identity x) -> x))

runResponseT
  :: forall e a.
     Hubot.Response
  -> ResponseT (Eff (response :: Hubot.RESPONSE | e)) a
  -> Hubot.ResponseEff e a
runResponseT r = runFreeT (lowerCoyoneda <<< hoistCoyoneda (interp r))

handle :: forall e a. Response a -> Hubot.Response -> Hubot.ResponseEff e a
handle = flip runResponse

interp :: forall e. Hubot.Response -> ResponseF ~> Hubot.ResponseEff e
interp r (Send m a) = const a <$> HResponse.send m r
interp r (Reply m a) = const a <$> HResponse.reply m r
