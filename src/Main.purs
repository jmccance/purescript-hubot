module Main (main) where

import Prelude
import Control.Monad.Eff (Eff)
import Data.Array (index)
import Data.Maybe (fromJust)
import Data.String (toUpper)
import Hubot (ROBOT, Robot)
import Hubot.Free (send, getMatch, respond, emote, reply, hear, robot)
import Partial.Unsafe (unsafePartial)

main :: Robot -> Eff (robot :: ROBOT) Unit
main = robot do
  hear    "orly"        $ const (send "yarly")
  respond "speak"       $ const do
                          reply "Arf!"
                          emote "wags their tail"
  respond "shout (.*)"  $ const do
                          match <- getMatch
                          send (toUpper $ unsafeIndex match 1)
  respond "echo"        \ m -> send m.text
  hear    "shout (.*)"  \ m -> send (toUpper m.text)
  where
    unsafeIndex as i = unsafePartial $ fromJust $ index as i
