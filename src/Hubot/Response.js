'use strict';

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
