A small development environment for compiling EPUB 3.3 packages
================================================================================

2024-01-03 No version number yet!

Confguration
--------------------------------------------------------------------------------

A few files need to be modified to adapt the environment to the project's needs.

#### .env

Defines environment variables common across the containers. This file contains
some default values that need to be modified according to your project's
requirements:

* GIT_AUTHOR_NAME and GIT_AUTHOR_EMAIL are used by Git.

* CONTAINER_USER is the name of the user account in the containers and also the
name of the user's home directory.

* REPOSITORY is the name of the folder where the repository is located, within
the home directory: /home/$USER/$REPOSITORY.

#### credentials/

This directory should contain a private and public key for authentication to
the repository. The credentials are only exposed to the Git container to ensure
that no malicious code in the development or testing containers can steal them.

#### scripts/build.sh

A script that watches the source directory, expected to be located at
/home/$USER/$REPOSITORY/src/ for changes and runs a sequence of commands
intended to compile the package and place it in the
/home/$USER/$REPOSITORY/dist/ directory.
***Note: The actual build sequence is not yet implemented.***

Getting started
--------------------------------------------------------------------------------

The environment defines three separate containers that need to be created by
running the following command once in the project's root directory:

```
docker-compose build
```

#### Git container

To clone an existing repository, or create a new one, start a shell in the Git
contaner:

```
docker-compose run git
```

To ensure the security of the credentials, the Git container must only contain
software from trusted sources. This container should be used to push changes,
and if your project resides in a private repository, also to fetch changes.

***Caution: Do not run untrusted scripts or executables in the Git container.***

#### Dev container

The Dev container is configured to run as a Docker service and is started with:

```
docker-compose up -d dev
```

It runs in the background and automatically triggers the build sequence when it
detects changes in any of the source files.

The build script expects that the source code of the EPUB package is
located in the /src directory. And the test script expects that the build
artefact is placed in the /dist directory. If your project is layed out
differently, update the scripts accordingly.

The Dev container should be responsible for setting up third party dependencies
and is assumed to run potentially unsafe code.

As a convenience for Visual Studio Code users, the ***code.sh*** script starts
the Dev container and runs Code in remote development mode towards it. Since the
container has Git installed, code changes can be committed from within. However,
to push the changes to the repository, the Git container needs to be used.

#### Test container

The Test container executes the script at *scripts/test.sh*, which monitors
the /dist directory for updates and runs the EPUBChecker tool from W3C against
the built aretefact. Currenly, it is hardcoded as *book.epub*. You may need to
adjust the expected file name in the script accordingly.

To verify the EPUB package's conformance to the specification:

```
docker-compose run test
```

Conclusion
--------------------------------------------------------------------------------

While this development environment is publicly accessible, it is primarily
designed as a personal tool and may not be universally suitable for all use
cases. Users are advised to carefully assess its compatibility with their
specific requirements and update it accordingly.

The software is released in the public domain under the MIT No Attribution
License. For more information see LICENSE.

The author assumes no responsibility for any issues or discrepancies that may
arise from the use of this software.

Please, also note that this project is currently a work in progress and many
features are not, and may never be, fully implemented. The author welcomes and
appreciates any forms of contributions, suggestions, and pull requests. If you
identify areas for improvement, encounter issues, or have ideas to enhance the
environment's functionality, please consider sharing your insights.

Thank you for your support and understanding.
