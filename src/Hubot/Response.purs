module Hubot.Response (
  ResponseEff
  , send
  ) where

import Prelude (Unit)

import Control.Monad.Eff (Eff)
import Data.Function.Uncurried (Fn2, runFn2)

import Hubot (RESPONSE, Response)

type ResponseEff e a = Eff (response :: RESPONSE | e) a

send :: forall e. String -> Response -> ResponseEff e Unit
send message resp = runFn2 _send message resp

foreign import _send :: forall e. Fn2
  String
  Response
  (ResponseEff e Unit)

-- These technically accept multiple strings. Not sure what the benefit of that
-- would be.

-- send :: String -> F Unit
-- emote :: String -> F Unit
-- reply :: String -> F Unit
-- topic :: String -> F Unit

-- What's a type that lets us extract a random value? List or Sequence is the easiest, but
-- random :: forall a. G a -> F a

-- Lower priority
-- play :: String -> F Unit
-- locked :: String -> F Unit
-- http :: Url -> HttpOptions -> F HttpResponse
