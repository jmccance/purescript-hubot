module Hubot where

import Prelude
import Control.Monad.Eff (Eff)
import Data.Array (tail)
import Data.Foreign.Class (class IsForeign, readProp)
import Data.Foreign.Null (unNull)
import Data.Foreign.NullOrUndefined (unNullOrUndefined)
import Data.Generic (gShow, class Generic)
import Data.Maybe (Maybe(Just, Nothing))

-- | The `RESPONSE` effect represents computations which send messages back to
-- | the chat.
foreign import data RESPONSE :: !

-- | The `ROBOT` effect represents computations which modify the Hubot bot.
-- | Generally this means it adds listeners.
foreign import data ROBOT :: !

foreign import data Brain     :: *
foreign import data Response  :: *
foreign import data Robot     :: *

type ResponseEff e a  = forall e. Eff (response :: RESPONSE | e) a
type RobotEff e a     = forall e. Eff (robot :: ROBOT | e) a

type MessageHandler m e = m -> Response -> ResponseEff e Unit

newtype User = User
  { id    :: String
  , name  :: String
  }

derive instance genericUser :: Generic User

instance showUser :: Show User where
  show = gShow

instance isForeignUser :: IsForeign User where
  read value = do
    id      <- readProp "id" value
    name    <- readProp "name" value
    pure $ User { id, name }

newtype CatchAllMessage = CatchAllMessage
  { id    :: String
  , user  :: User
  -- TODO Add Message type back in?
  }

derive instance genericCatchAllMessage :: Generic CatchAllMessage
instance showCatchAllMessage :: Show CatchAllMessage where
  show = gShow

instance isForeignCatchAllMessage :: IsForeign CatchAllMessage where
  read value = do
    message <- readProp "message" value
    id      <- readProp "id" message
    user    <- readProp "user" message
    pure $ CatchAllMessage { id, user }

newtype EnterMessage = EnterMessage
  { id    :: String
  , user  :: User
  }

derive instance genericEnterMessage :: Generic EnterMessage
instance showEnterMessage :: Show EnterMessage where
  show = gShow

instance isForeignEnterMessage :: IsForeign EnterMessage where
  read value = do
    message <- readProp "message" value
    id      <- readProp "id" message
    user    <- readProp "user" message
    pure $ EnterMessage { id, user }

newtype LeaveMessage = LeaveMessage
  { id    :: String
  , user  :: User
  }

derive instance genericLeaveMessage :: Generic LeaveMessage
instance showLeaveMessage :: Show LeaveMessage where
  show = gShow

instance isForeignLeaveMessage :: IsForeign LeaveMessage where
  read value = do
    message <- readProp "message" value
    id      <- readProp "id" message
    user    <- readProp "user" message
    pure $ LeaveMessage { id, user }

newtype TextMessage = TextMessage
  { id    :: String
  , user  :: User
  , text  :: String
  , match :: Array (Maybe String)
  }

derive instance genericTextMessage :: Generic TextMessage

instance showTextMessage :: Show TextMessage where
  show = gShow

instance isForeignTextMessage :: IsForeign TextMessage where
  read value = do
    message     <- readProp "message" value
    id          <- readProp "id"      message
    user        <- readProp "user"    message
    text        <- readProp "text"    message
    nullMatch   <- readProp "match"   value

    let match = thisOrNil $ tail (unNullOrUndefined <$> nullMatch)
    pure $ TextMessage { id, user, text, match }

    where
      thisOrNil (Just x)  = x
      thisOrNil Nothing   = []

newtype TopicMessage = TopicMessage
  {  id   :: String
  , text  :: String
  }

derive instance genericTopicMessage :: Generic TopicMessage

instance showTopicMessage :: Show TopicMessage where
  show = gShow

instance isForeignTopicMessage :: IsForeign TopicMessage where
  read value = do
    message <- readProp "message" value
    id      <- readProp "id" message
    text    <- readProp "text" message
    pure $ TopicMessage { id, text }
