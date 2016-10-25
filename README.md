purescript-hubot
================

**This library is a work in progress.**

PureScript API for implementing Hubot scripts. Example:

```purescript
main :: Robot -> Eff (robot :: ROBOT) Unit
main = robot do
  hear    "orly"       $  send "yarly"
  respond "speak (.*)" do
                          reply "Let me think about that..."
                          match <- getMatch
                          send (unsafePartial $ fromJust $ index match 1)
```

To try it out, run

```
npm install && npm start
```

The FFI for Hubot is in Hubot, Hubot.Response, and Hubot.Robot. A Free monad-based DSL is provided in Hubot.Free.
