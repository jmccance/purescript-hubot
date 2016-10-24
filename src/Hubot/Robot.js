'use strict';

exports._hear = function (pattern, callback, robot) {
  return function () {
    robot.hear(
      pattern,
      function (r) {
        callback(r)();
      }
    );
  };
};
