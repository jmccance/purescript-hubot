module Main (main) where

import Control.Monad.Eff (Eff)
import Data.Array (index)
import Data.Maybe (fromJust)
import Data.String (toUpper)
import Hubot (ROBOT, Robot)
import Hubot.Free (send, getMatch, respond, emote, reply, hear, robot)
import Partial.Unsafe (unsafePartial)
import Prelude (Unit, bind, ($))

main :: Robot -> Eff (robot :: ROBOT) Unit
main = robot do
  hear    "orly"        $ send "yarly"
  respond "speak"       do
                          reply "Arf!"
                          emote "wags their tail"
  respond "shout (.*)"  do
                          match <- getMatch
                          send (toUpper $ unsafeIndex match 1)
  where
    unsafeIndex as i = unsafePartial $ fromJust $ index as i
