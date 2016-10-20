"use strict";

exports._hear = function (pattern) {
  return function (callback) {
    return function (robot) {
      return function () {
        robot.hear(pattern, callback);
      };
    };
  };
};

exports._listen = function (matcher) {
  return function (callback) {
    return function (robot) {
      return function () {
        robot.listen(matcher, callback);
      };
    };
  };
};

exports._respond = function (pattern) {
  return function (callback) {
    return function (robot) {
      return function () {
        robot.respond(pattern, callback);
      };
    };
  };
};
