module Main (main) where

import Prelude
import Control.Monad.Eff (Eff)
import Data.Maybe (Maybe(Just))
import Data.String (toUpper)
import Hubot (TextMessage(TextMessage), ROBOT, Robot)
import Hubot.Free (send, respond, emote, reply, hear, robot)

main :: Robot -> Eff (robot :: ROBOT) Unit
main = robot do
  hear    "orly"        $ const (send "yarly")
  respond "speak"       $ const do
                          reply "Arf!"
                          emote "wags their tail"
  respond "shout (.*)"  \ (TextMessage m) ->
                          case m.match of
                            [_, Just toShout] -> send (toUpper toShout)
                            _ -> pure unit
  respond "debug"       \ m -> send $ show m
  hear    "debug"       \ m -> send $ show m
