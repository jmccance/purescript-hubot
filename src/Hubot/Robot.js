'use strict';

exports._catchAll = function (callback, robot) {
  return function () {
    robot.catchAll(
      function (r) { callback(r)(); }
    );
  }
};

exports._enter = function (callback, robot) {
  return function () {
    robot.enter(
      function (r) { callback(r)(); }
    );
  }
};

exports._hear = function (pattern, callback, robot) {
  return function () {
    robot.hear(
      RegExp(pattern),
      function (r) { callback(r)(); }
    );
  };
};

exports._leave = function (callback, robot) {
  return function () {
    robot.leave(
      function (r) { callback(r)(); }
    );
  }
};

exports._respond = function (pattern, callback, robot) {
  return function () {
    robot.respond(
      RegExp(pattern),
      function (r) { callback(r)(); }
    );
  };
};

exports._topic = function (callback, robot) {
  return function () {
    robot.topic(
      function (r) { callback(r)(); }
    );
  }
};
