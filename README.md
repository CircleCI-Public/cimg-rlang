<div align="center">
	<p>
		<img alt="CircleCI Logo" src="https://raw.github.com/CircleCI-Public/cimg-r/main/img/circle-circleci.svg?sanitize=true" width="75" />
		<img alt="Docker Logo" src="https://raw.github.com/CircleCI-Public/cimg-r/main/img/circle-docker.svg?sanitize=true" width="75" />
		<img alt="R Logo" src="https://raw.github.com/CircleCI-Public/cimg-r/main/img/circle-r.svg?sanitize=true" width="75" />
	</p>
	<h1>CircleCI Convenience Images => R Lang</h1>
	<h3>A Continous Integration focused R Docker image built to run on CircleCI</h3>
</div>

[![CircleCI Build Status](https://circleci.com/gh/CircleCI-Public/cimg-r.svg?style=shield)](https://circleci.com/gh/CircleCI-Public/cimg-r) [![Software License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/CircleCI-Public/cimg-r/main/LICENSE) [![Docker Pulls](https://img.shields.io/docker/pulls/cimg/node)](https://hub.docker.com/r/cimg/r) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/circleci-images) [![Repository](https://img.shields.io/badge/github-README-brightgreen)](https://github.com/CircleCI-Public/cimg-r)

**_This image is currently in ALPHA development stages and should not be used in production._**

**As such, we would love to get your thoughts and feedback on packages to include which can aid you in your developer experience. Please see the `contributing` section of the README for additional details on what this should look like and what we would like to see as considerations for inclusion within this image**

`cimg/r` is a Docker image created by CircleCI with continuous integration builds in mind.
Each tag contains a version of R, `littler`, `docopt`, and any binaries and tools that are required for builds to complete successfully in a CircleCI environment.

## Table of Contents

- [Getting Started](#getting-started)
- [How This Image Works](#how-this-image-works)
- [Development](#development)
- [Contributing](#contributing)
- [Additional Resources](#additional-resources)
- [License](#license)

## Getting Started

This image can be used with the CircleCI `docker` executor.
For example:

```yaml
jobs:
  build:
    docker:
      - image: cimg/r:4.2.0
    steps:
      - checkout
      - run: R --version
```

In the above example, the CircleCI R Docker image is used for the primary container.
More specifically, the tag `4.2.0` is used meaning the version of R will be R 4.2.0.

## How This Image Works

This image contains the R programming language and it's dependencies.
The apt PPA repositories for `marutter` and `c2d4u` have been added for versions of versions 4.0+
You can also install R packages using `install.packages()` or `install(2).r`

### Variants

Variant images typically contain the same base software, but with a few additional modifications. As of now, no variants exist,
however, there are four candidates that are being considered:
- tidyverse
- geospatial
- binder
- shiny

### Tagging Scheme

This image has the following tagging scheme:

```text
cimg/node:<R-version>
```

## Development

Images can be built and run locally with this repository.
This has the following requirements:

- local machine of Linux (Ubuntu tested) or macOS
- modern version of Bash (v4+)
- modern version of Docker Engine (v19.03+)

### Cloning For Community Users (no write access to this repository)

Fork this repository on GitHub.
When you get your clone URL, you'll want to add `--recurse-submodules` to the clone command in order to populate the Git submodule contained in this repo.
It would look something like this:

```bash
git clone --recurse-submodules <my-clone-url>
```

If you missed this step and already cloned, you can just run `git submodule update --recursive` to populate the submodule.
Then you can optionally add this repo as an upstream to your own:

```bash
git remote add upstream https://github.com/CircleCI-Public/cimg-r.git
```

### Cloning For Maintainers ( you have write access to this repository)

Clone the project with the following command so that you populate the submodule:

```bash
git clone --recurse-submodules git@github.com:CircleCI-Public/cimg-r.git
```

### Generating Dockerfiles

Dockerfiles can be generated for a specific R version using the `gen-dockerfiles.sh` script.
For example, to generate the Dockerfile for R v4.2.0, you would run the following from the root of the repo:

```bash
./shared/gen-dockerfiles.sh 4.2.0
```

The generated Dockerfile will be located at `./4.2/Dockefile`.
To build this image locally and try it out, you can run the following:

```bash
cd 4.2
docker build -t test/r:4.2.0 .
docker run -it test/r:4.2.0 bash
```

### Building the Dockerfiles

To build the Docker images locally as this repository does, you'll want to run the `build-images.sh` script:

```bash
./build-images.sh
```

This would need to be run after generating the Dockerfiles first.
When releasing proper images for CircleCI, this script is run from a CircleCI pipeline and not locally.

### Publishing Official Images (for Maintainers only)

The individual scripts (above) can be used to create the correct files for an image, and then added to a new git branch, committed, etc.
A release script is included to make this process easier.
To make a proper release for this image, lets's use the fake R version of R v9.99, you would run the following from the repo root:

```bash
./shared/release.sh 9.99
```

This will automatically create a new Git branch, generate the Dockerfile(s), stage the changes, commit them, and push them to GitHub.
The commit message will end with the string `[release]`.
This string is used by CircleCI to know when to push images to Docker Hub.
"alias" would be "current" or "lts" depending on the version.
All that would need to be done after that is:

- wait for build to pass on CircleCI
- review the PR
- merge the PR

The main branch build will then publish a release.

### Incorporating Changes

How changes are incorporated into this image depends on where they come from.

**build scripts** - Changes within the `./shared` submodule happen in its [own repository](https://github.com/CircleCI-Public/cimg-shared).
For those changes to affect this image, the submodule needs to be updated.
Typically like this:

```bash
cd shared
git pull
cd ..
git add shared
git commit -m "Updating submodule for foo."
```

**parent image** - By design, when changes happen to a parent image, they don't appear in existing Node.js images.
This is to aid in "determinism" and prevent breaking customer builds.
New Node.js images will automatically pick up the changes.

If you _really_ want to publish changes from a parent image into the Node.js image, you have to build a specific image version as if it was a new image.
This will create a new Dockerfile and once published, a new image.

**Node specific changes** - Editing the `Dockerfile.template` file in this repo is how to modify the Node.js image specifically.
Don't forget that to see any of these changes locally, the `gen-dockerfiles.sh` script will need to be run again (see above).

## Contributing

We encourage [issues](https://github.com/CircleCI-Public/cimg-r/issues) to and [pull requests](https://github.com/CircleCI-Public/cimg-r/pulls) against this repository however, in order to value your time, here are some things to consider:

1. We won't include just anything in this image. In order for us to add a tool within the R image, it has to be something that is maintained and useful to a large number of R developers. Every tool added makes the image larger and slower for all users so being thorough on what goes in the image will benefit everyone. While there are exceptions, and we can certainly work with you on creating a potential variant, the general rule of thumb for including a tool that at least 80% of users will use..
1. PRs are welcome. If you have a PR that will potentially take a large amount of time to make, it will be better to open an issue to discuss it first to make sure it's something worth investing the time in.
1. Issues should be to report bugs or request additional/removal of tools in this image. For help with images, please visit [CircleCI Discuss](https://discuss.circleci.com/c/ecosystem/circleci-images).

## Additional Resources

[CircleCI Docs](https://circleci.com/docs/) - The official CircleCI Documentation website.  
[CircleCI Configuration Reference](https://circleci.com/docs/2.0/configuration-reference/#section=configuration) - From CircleCI Docs, the configuration reference page is one of the most useful pages we have.
It will list all of the keys and values supported in `.circleci/config.yml`.  
[Docker Docs](https://docs.docker.com/) - For simple projects this won't be needed but if you want to dive deeper into learning Docker, this is a great resource.

## License

This repository is licensed under the MIT license.
The license can be found [here](./LICENSE).
