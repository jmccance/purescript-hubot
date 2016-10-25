module Hubot (
  RESPONSE
  , ROBOT
  , Brain
  , Message
  , Response
  , ResponseEff
  , ResponseHandler
  , Robot
  , RobotEff
  , User
  ) where

import Prelude

import Control.Monad.Eff (Eff)


-- | The `RESPONSE` effect represents computations which send messages back to
-- | the chat.
foreign import data RESPONSE :: !

-- | The `ROBOT` effect represents computations which modify the Hubot bot.
-- | Generally this means it adds listeners.
foreign import data ROBOT :: !

foreign import data Brain     :: *
foreign import data Message   :: *
foreign import data Response  :: *
foreign import data Robot     :: *
foreign import data User      :: *

type ResponseEff e a = Eff (response :: RESPONSE | e) a
type ResponseHandler e = forall e. Response -> ResponseEff e Unit

type RobotEff e a = forall e. Eff (robot :: ROBOT | e) a
