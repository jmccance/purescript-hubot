module Hubot.Response (
  emote
  , getMatch
  , reply
  , send
  ) where

import Prelude (Unit)

import Data.Function.Uncurried (Fn1, Fn2, runFn1, runFn2)

import Hubot (Response, ResponseEff)

emote :: forall e. String -> Response -> ResponseEff e Unit
emote emotion resp = runFn2 _emote emotion resp

foreign import _emote :: forall e. Fn2
  String
  Response
  (ResponseEff e Unit)

getMatch :: forall e. Response -> ResponseEff e (Array String)
getMatch resp = runFn1 _getMatch resp

foreign import _getMatch :: forall e. Fn1
  Response
  (ResponseEff e (Array String))

reply :: forall e. String -> Response -> ResponseEff e Unit
reply message resp = runFn2 _reply message resp

foreign import _reply :: forall e. Fn2
  String
  Response
  (ResponseEff e Unit)

send :: forall e. String -> Response -> ResponseEff e Unit
send message resp = runFn2 _send message resp

foreign import _send :: forall e. Fn2
  String
  Response
  (ResponseEff e Unit)
