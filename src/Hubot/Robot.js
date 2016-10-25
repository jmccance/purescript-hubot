'use strict';

exports._hear = function (pattern, callback, robot) {
  return function () {
    robot.hear(
      RegExp(pattern),
      function (r) { callback(r)(); }
    );
  };
};

exports._respond = function (pattern, callback, robot) {
  return function () {
    robot.respond(
      RegExp(pattern),
      function (r) { callback(r)(); }
    );
  };
};
