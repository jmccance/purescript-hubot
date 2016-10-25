'use strict';

exports._emote = function (emotion, response) {
  return function () {
    response.emote(emotion);
  };
};

exports._getMatch = function (response) {
  return function () {
    return response.match;
  };
};

exports._reply = function (message, response) {
  return function () {
    response.reply(message);
  };
};

exports._send = function (message, response) {
  return function () {
    response.send(message);
  };
};
