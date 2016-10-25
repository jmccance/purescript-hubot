'use strict';

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
