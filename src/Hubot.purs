module Hubot (
  RESPONSE
  , ROBOT
  , Brain
  , Message
  , Response
  , Robot
  , User
  ) where

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
