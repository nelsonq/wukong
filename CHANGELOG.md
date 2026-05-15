# Change Log

This change log summarizes repository history by category.

## `1.0.0`

### New Features

- [WUKONG-92] Add snapshot build command for api-platform.
- [WUKONG-93] Support cargo run for web apps.
- [WUKONG-89] Add alias support for parallel build.
- [WUKONG-83] Support Zulu JDK 11.
- [WUKONG-76] Add `myepmvn-gooffline`.
- [WUKONG-70] Support multithreaded build built-in command.
- [WUKONG-61] Add Apple platform support for MySQL Docker.
- [WUKONG-58] Add alias to run Selenium container.
- [WUKONG-57] Add alias for Selenium tests.
- [WUKONG-54] Apply Tomcat 8 as default to EP application startup command.
- [WUKONG-50] Use OOTB MySQL image instead of personal MySQL image.
- [WUKONG-48] Support 4 digit port.
- [WUKONG-44] Add sync target port support.
- [WUKONG-38] Add MySQL 5.7 RC Docker file support.
- [WUKONG-37] Add EP 8.2.x support.
- [WUKONG-29] Add support for YourKit.
- [WUKONG-26] Support loading MySQL 5.7 RC.
- [WUKONG-20] Add image creation and removal support.
- [WUKONG-20] Support database recognition.
- [WUKONG-19] Add Oracle support.
- [WUKONG-16] Support creating snapshot for Docker container.
- [WUKONG-15] Add EP 8.0.x support.
- [WUKONG-13] Add EP 7.6 support.
- [WUKONG-11] Add support for starting batch server.
- [WUKONG-7] Add Vancouver timezone support.
- [WUKONG-8] Support Zulu JDK for 7.5wq.
- [WUKONG-5] Add Docker image cleanup command.
- [ENV-2] Add Linux Java home support.
- Add Tomcat 8 aliases support.
- Add EP 6.16 version support.

### Improvements

- [WUKONG-85] Remove `JAVA_HOME` variable.
- [WUKONG-79] Add `-nsu` to `basemvn`.
- [WUKONG-78] Update alias for multi-thread build.
- [WUKONG-74] Upgrade toolchain with Maven 3.9.0.
- [WUKONG-69] Extend Xmx memory option to 4000 MB.
- [WUKONG-66] Add `-nsu` when starting Tomcat to avoid downloading snapshots from Maven repository.
- [WUKONG-64] Update Docker built-in environment variable.
- [WUKONG-62] Simplify Zulu JDK 275 and `MAVEN_OPTS_339`.
- [WUKONG-54] Tidy up README.
- [WUKONG-43] Update `init-product-contribution-project.sh` repository.
- [WUKONG-41] Bypass volume configuration to retain data in container.
- [WUKONG-20] Improve scripts for user friendliness.
- Update README documentation.
- Initialize project.

### Bug Fixes

- [WUKONG-69] Fix issue.
- [WUKONG-52] Fix issue.
