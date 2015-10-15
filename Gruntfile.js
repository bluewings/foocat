/* jslint regexp: true */
'use strict';

module.exports = function (grunt) {

  var yeoman = {
    srcpath: {
      mochaTest: {
        src: ['*.spec.coffee']
      }
    }
  };

  function generateFiles(data) {
    var cwd, file, i, len, src;
    data.files = [];
    if (!data.src) {
      return;
    }
    src = typeof data.src === 'string' ? [data.src] : data.src;
    if (data.cwd) {
      cwd = data.cwd + '/';
    } else {
      cwd = '';
    }
    for (i = 0, len = src.length; i < len; i++) {
      file = src[i];
      data.files.push(file.replace(/^([!]{0,1})/, '$1' + cwd));
    }
  }

  Object.keys(yeoman.srcpath).forEach(function (name) {
    generateFiles(yeoman.srcpath[name]);
  });

  require('jit-grunt')(grunt);

  // Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt);

  // Define the configuration for all the tasks
  grunt.initConfig({

    watch: {
      mochaTest: {
        files: yeoman.srcpath.mochaTest.files,
        tasks: ['mochaTest']
      }
    },

    mochaTest: {
      options: {
        reporter: 'spec',
        require: 'coffee-script/register'
      },
      src: yeoman.srcpath.mochaTest.files
    }
  });
};