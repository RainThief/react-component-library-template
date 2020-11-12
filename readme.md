# React Component Library Boilerplate

This will create a React Component Library complete with StoryBook and Jest for building components to publish to a NPM Package

## Component Development

### Requirements

To develop components you will need installed

* [Node.js v12](https://nodejs.org/en/download/)
* [Docker](https://docs.docker.com/get-docker/)
* Bash
  * [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
  * [Cygwin](https://www.cygwin.com/)

### Project structure

#### `/.storybook`

Story book configuration files.

#### `/scripts`

Scripts to perform various build, install, analysis, etc operations.

#### `/src`

Component, tests and stories files.

As an example, for an alert component the folder `src/alert` will contain

*`alert.tsx`*

The component file

*`alert.stories.tsx`*

The storybook file to help develop the component and documentation

*`alert.test.tsx`*

The jest test file to declare the unit tests for the component

*`alert.scss`*

The styling information for the component

### Commands

#### `$ yarn run test`

Runs the Jest testing framework against all `*.test.(tsx|ts)` files in `src` folder.

Example output

```shell
PASS  src/alert/alert.test.tsx
  Alert
    ✓ renders correctly (13 ms)
    when only the description is specified
      ✓ should not render the close button (6 ms)
      ✓ should not render the title (1 ms)
      ✓ should render the description (2 ms)
    when the description and title is specified
      ✓ should not render the close button (2 ms)
      ✓ should render the title (1 ms)
      ✓ should render the description (1 ms)
    when the onClose callback is specified
      ✓ should render the close button (2 ms)
      when the close button is clicked
        ✓ should hide the alert (5 ms)

-----------|---------|----------|---------|---------|-------------------
File       | % Stmts | % Branch | % Funcs | % Lines | Uncovered Line #s
-----------|---------|----------|---------|---------|-------------------
All files  |     100 |     87.5 |     100 |     100 |
 alert.tsx |     100 |     87.5 |     100 |     100 | 20
-----------|---------|----------|---------|---------|-------------------
Test Suites: 1 passed, 1 total
Tests:       9 passed, 9 total
Snapshots:   1 passed, 1 total
Time:        2.061 s, estimated 4 s
Ran all test suites.
Unit tests passed
Done in 3.70s.
```

#### `$ yarn run lint`

Runs static analysis checks against source files.  This will check coding standards for JavaScript, TypeScript, CSS and SASS as well as check for code security vulnerabilities.

Example output

```shell
static analysis passed
Done in 2.36s.
```

#### `$ yarn run audit`

Checks third party dependencies for

* Compatible licenses
* Security vulnerabilities
* Updated versions

Example output

```shell
yarn audit v1.22.4
0 vulnerabilities found - Packages audited: 2873
Done in 1.50s.
yarn outdated v1.22.4
Done in 2.80s.
Audit passed
```

#### `$ yarn run storybook`

Starts storybook application to aid with component development

Example output

```shell
start-storybook -p 6006
info @storybook/react v6.0.5
info
info => Loading presets
info => Loading presets
info => Loading config/preview file in "./.storybook".
info => Adding stories defined in ".storybook/main.js".
info => Using default Webpack setup.
webpack built b746a705ca2ce8979804 in 5781ms
╭───────────────────────────────────────────────────╮
│                                                   │
│   Storybook 6.0.5 started                         │
│   5.06 s for manager and 6.82 s for preview       │
│                                                   │
│    Local:            http://localhost:6006/       │
│    On your network:  http://192.168.0.39:6006/    │
│                                                   │
╰───────────────────────────────────────────────────╯
```

#### `$ yarn run build-storybook`

Exports storybook data for all components with configured stories as static webpages

Example output

```shell
info @storybook/react v6.0.5
info
info clean outputDir..
info => Copying prebuild dll's..
info => Building manager..
info => Loading manager config..
info => Loading presets
info => Compiling manager..
info => manager built (6.03 s)
info => Building preview..
info => Loading preview config..
info => Loading presets
info => Loading config/preview file in "./.storybook".
info => Adding stories defined in ".storybook/main.js".
info => Using default Webpack setup.
info => Compiling preview..
info => Preview built (8.24 s)
info => Output directory: /media/storage/projects/react-lib-installer/storybook-static
Done in 15.45s.
```

#### `$ yarn run build`

Builds all TypeScript source files into common js and modules

Example output

```shell
rollup -c

./src/index.ts → build/cjs/index.js, build/es/index.js...
created build/cjs/index.js, build/es/index.js in 2s
Done in 2.45s.
```
