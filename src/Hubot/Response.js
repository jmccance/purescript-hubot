'use strict';

exports._send = function (message, response) {
  return function () {
    response.send(message);
  };
};
