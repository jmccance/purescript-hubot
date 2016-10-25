module Main (main) where

import Prelude (Unit, bind, ($))

import Control.Monad.Eff (Eff)
import Data.Array (index)
import Data.Maybe (fromJust)
import Data.String (toUpper)
import Partial.Unsafe (unsafePartial)

import Hubot.Free (send, getMatch, respond, emote, reply, hear, robot)
import Hubot (ROBOT, Robot)

main :: Robot -> Eff (robot :: ROBOT) Unit
main = robot do
  hear    "orly"        $ send "yarly"
  respond "speak"       do
                          reply "Arf!"
                          emote "wags their tail"
  respond "shout (.*)"  do
                          match <- getMatch
                          send (toUpper $ second match)
  where
    second a = unsafePartial $ fromJust $ index a 1
