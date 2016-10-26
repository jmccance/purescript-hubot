module Hubot where

import Prelude
import Control.Monad.Eff (Eff)

-- | The `RESPONSE` effect represents computations which send messages back to
-- | the chat.
foreign import data RESPONSE :: !

-- | The `ROBOT` effect represents computations which modify the Hubot bot.
-- | Generally this means it adds listeners.
foreign import data ROBOT :: !

foreign import data Brain     :: *
foreign import data Response  :: *
foreign import data Robot     :: *
foreign import data User      :: *
foreign import data Room      :: *

type ResponseEff e a = Eff (response :: RESPONSE | e) a
type MessageHandler m e = forall e. m -> Response -> ResponseEff e Unit

type RobotEff e a = forall e. Eff (robot :: ROBOT | e) a

type TextMessage =
  { id    :: String
  , room  :: Room
  , user  :: User
  , text  :: String
  }

type EnterMessage =
  { id    :: String
  , room  :: Room
  , user  :: User
  }

type LeaveMessage =
  { id    :: String
  , room  :: Room
  , user  :: User
  }

type TopicMessage =
  {  id    :: String
  , room  :: Room
  , text  :: String
  }

type CatchAllMessage =
  { id :: String
  , room  :: Room
  , user  :: User
  -- TODO Add Message type back in?
  }
