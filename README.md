# Array Utilities Unit

## Description

The `DelphiDabbler.Lib.ArrayUtils.pas` unit provides a single "Advanced" record, _TArrayUtils_, that contains static methods that manipulate generic arrays.

For full details of the available methods, and examples of use, see the comprehensive [online documentation](https://delphidabbler.com/url/arrayutils-docs). There is no help file.

_DUnit_ tests for _TArrayUtils_ are included in the download along with a demo project that contains all the example code that is included in the documentation.

> ⚠️ **Warning:** This is v0.x initial development code. Anything _**may**_ change at any time. The public API _**should not**_ be considered stable.
>
> Once v1.0.0 has been released then the API will be stable and the principles of [semantic versioning](https://semver.org/) will be followed.

## Compatibility

This unit requires Delphi XE as a minimum and has been tested on Delphi XE (32 bit build) and Delphi 12 (32 bit and 64 bit builds).

## Installation

The _Array Utilities Unit_ documentation, test suite and demo code are supplied in a zip file. Before installing you need to extract all the files from the zip file, preserving the directory structure. The following files will be extracted:

* **`DelphiDabbler.Lib.ArrayUtils.pas`** – Main source code.
* `README.md` – The unit's read-me file.
* `MPL-2.txt` – Mozilla Public License v2.0.
* `CHANGELOG.md` – The project's change log.
* `Documentation.URL` – Short-cut to the online documentation.

In addition to the above files you will find the _DUnit_ tests in the `Test` sub-directory and the demo code in the `Demos` sub-directory.

There are four possible ways to use the unit.

1. The simplest way is to add `DelphiDabbler.Lib.ArrayUtils.pas` to your projects as you need it.
2. To make the unit easier to re-use you can either copy it to a folder on your Delphi search path, or add the folder containing the unit to the Delphi Search path. You then simply use the unit as required without needing to add it to your project.
3. For maximum portability you can add the unit to a Delphi package. If you need help doing this [see here](https://delphidabbler.com/url/install-comp).
4. If you use Git you can add the [`ddablib/arrayutils`](https://github.com/ddablib/arrayutils) GitHub repository as a Git submodule and add it to your project. Obviously, it's safer if you fork the repo and use your copy, just in case `ddablib/arrayutils` ever goes away.

## Update History

A complete change log is provided in the file [`CHANGELOG.md`](https://github.com/ddablib/arrayutils/blob/main/CHANGELOG.md) that is included in the download.

## License

The _Array Utilities Unit_ (`DelphiDabbler.Lib.ArrayUtils.pas`) is released under the terms of the [Mozilla Public License v2.0](https://www.mozilla.org/MPL/2.0/).

All relevant trademarks are acknowledged.

## Bugs and Feature Requests

Bugs can be reported or new features requested via the project's [Issue Tracker](https://github.com/ddablib/arrayutils/issues). A GitHub account is required.

Please check if an issue has already been created for a similar report or request. If so then please add a comment containing as much information you can to the existing issue, or if you've nothing to add, just add a :+1: (`:+1:`) comment. If there is no suitable existing issue then please add a new issue and give as much information as possible.

## About the Author

I'm Peter Johnson – a hobbyist programmer living in Ceredigion in West Wales, UK, writing mainly in Delphi. My programs and other library code are available from: [https://delphidabbler.com/](https://delphidabbler.com/).

This document is copyright © 2025, [Peter Johnson](https://gravatar.com/delphidabbler).
