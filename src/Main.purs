module Main (main) where

import Prelude
import Control.Monad.Eff (Eff)

import Hubot (ROBOT, Robot)
import Hubot.Robot (withRobot, hear)
import Hubot.Response (send)

main :: Robot -> Eff (robot :: ROBOT) Unit
main = withRobot do
  hear "orly" (send "yarly")
  hear "yarly" (send "orly")

-- This is actually fine, in that it takes a Response and returns an effect. Response is kept opaque, so we can't dig into it and get stuff out. This is good, because in PS code we can't willy-nilly call response methods.

-- That said, we do want to be able to act on messages. So one way of doing this will be to create a function like:

-- handle :: (ChatEvent -> ResponseEff e Unit) -> Response -> ResponseEff e Unit

-- That will expose the static data of the event without giving full access to the Response object.
