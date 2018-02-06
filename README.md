# Onz

Onz is a next generation crypto-currency and decentralized application platform, written entirely in JavaScript. For more information please refer to our website: https://onzcoin.com/.

[![Build Status](https://travis-ci.org/OnzCoin/onz.svg?branch=development)](https://travis-ci.org/OnzCoin/onz)
[![Coverage Status](https://coveralls.io/repos/github/OnzCoin/onz/badge.svg?branch=development)](https://coveralls.io/github/OnzCoin/onz?branch=development)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)
[![Join the chat at https://gitter.im/OnzCoin/onz](https://badges.gitter.im/OnzCoin/onz.svg)](https://gitter.im/OnzCoin/onz?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

**NOTE:** The following information is applicable to: **Ubuntu 14.04, 16.04 (LTS) or 16.10 - x86_64**.

## Prerequisites

- Make sure the following ports are opened.

  ```
  MAINNET: 11000 and 11001
  TESTNET: 10998 and 10999
  ```


## Installation Steps

Clone the Onz repository to your home directory using Git.

```
cd ~
git clone https://github.com/OnzCoin/onz.git
```

Go to the onz directory and run the install command.

```
cd onz
./onz_manager.bash install
```

After installation complete, run the clean_start to start up the node.

```
./onz_manager.bash clean_start
```

## Managing Onz

To start the node, run the following command:

`./onz_manager.bash start`

To reload the node after modify config file, run the following command:

`./onz_manager.bash reload`

To stop the node, run the following command:

`./onz_manager.bash stop`

To check the status and block height, run the following command:

`./onz_manager.bash status`


## Authors

- Kan Wong <kan@onzcoin.com>
- Mars Yau <mars@onzcoin.com>
- Karek <karek314@protonmail.ch>
- Boris Povod <boris@crypti.me>
- Pavel Nekrasov <landgraf.paul@gmail.com>
- Sebastian Stupurac <stupurac.sebastian@gmail.com>
- Oliver Beddows <oliver@lightcurve.io>
- Isabella Dell <isabella@lightcurve.io>
- Marius Serek <mariusz@serek.net>
- Maciej Baj <maciej@lightcurve.io>

## License

Copyright © 2017-2018 ONZ COIN<br>
Copyright © 2016-2017 Lisk Foundation<br>

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the [GNU General Public License](https://github.com/OnzCoin/onz/tree/master/LICENSE) along with this program.  If not, see <http://www.gnu.org/licenses/>.

***

This program also incorporates work previously released with lisk `0.7.0` (and earlier) versions under the [MIT License](https://opensource.org/licenses/MIT). To comply with the requirements of that license, the following permission notice, applicable to those parts of the code only, is included below:

Copyright © 2016-2017 Lisk Foundation<br>
Copyright © 2015 Crypti<br>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
