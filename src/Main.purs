module Main (main) where

import Prelude
import Control.Monad.Eff (Eff)
import Data.Array (index)
import Data.Maybe (fromJust)
import Hubot (ROBOT, Robot)
import Hubot.Free (send, hear, robot, respond, reply, getMatch)
import Partial.Unsafe (unsafePartial)

main :: Robot -> Eff (robot :: ROBOT) Unit
main = robot do
  hear    "orly"       $  send "yarly"
  respond "speak (.*)" do
                          reply "Let me think about that..."
                          match <- getMatch
                          send (unsafePartial $ fromJust $ index match 1)
