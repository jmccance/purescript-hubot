module Hubot.Response (
  reply
  , send
  ) where

import Data.Function.Uncurried (Fn2, runFn2)
import Hubot (ResponseEff, Response)
import Prelude (Unit)


send :: forall e. String -> Response -> ResponseEff e Unit
send message resp = runFn2 _send message resp

foreign import _send :: forall e. Fn2
  String
  Response
  (ResponseEff e Unit)

reply :: forall e. String -> Response -> ResponseEff e Unit
reply message resp = runFn2 _reply message resp

foreign import _reply :: forall e. Fn2
  String
  Response
  (ResponseEff e Unit)
