# Onz

Onz is a next generation crypto-currency and decentralized application platform, written entirely in JavaScript. For more information please refer to our website: https://onzcoin.com/.

[![Build Status](https://travis-ci.org/OnzCoin/onz.svg?branch=development)](https://travis-ci.org/OnzCoin/onz)
[![Coverage Status](https://coveralls.io/repos/github/OnzCoin/onz/badge.svg?branch=development)](https://coveralls.io/github/OnzCoin/onz?branch=development)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)
[![Join the chat at https://gitter.im/OnzCoin/onz](https://badges.gitter.im/OnzCoin/onz.svg)](https://gitter.im/OnzCoin/onz?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

**NOTE:** The following information is applicable to: **Ubuntu 14.04, 16.04 (LTS) or 16.10 - x86_64**.

## Prerequisites - In order

  ```
  useradd -d /home/onzcoin -m onzcoin
  groupadd sudo
  usermod -a -G sudo onzcoin
  passwd onzcoin
  ```

- Tool chain components + git

  `sudo apt-get install -y python build-essential curl automake autoconf libtool git`


- Node.js (<https://nodejs.org/>) -- Node.js serves as the underlying engine for code execution.

  System wide via package manager:

  ```
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
  sudo apt-get install -y nodejs
  ```

  Locally using [nvm](https://github.com/creationix/nvm):

  ```
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
  nvm install v6.10.1
  ```

- Install PostgreSQL (version 9.6.2):

  ```
  curl -sL "https://downloads.onzcoin.com/scripts/setup_postgresql.Linux" | bash -
  sudo -u postgres createuser --createdb $USER
  createdb onz_test
  createdb onz_main
  sudo -u postgres psql -d onz_test -c "alter user "$USER" with password 'password';"
  sudo -u postgres psql -d onz_main -c "alter user "$USER" with password 'password';"
  ```

- Bower (<http://bower.io/>) -- Bower helps to install required JavaScript dependencies.

  `npm install -g bower`

- Grunt.js (<http://gruntjs.com/>) -- Grunt is used to compile the frontend code and serves other functions.

  `npm install -g grunt-cli`

- PM2 (<https://github.com/Unitech/pm2>) -- PM2 manages the node process for Onz (Optional)

  `npm install -g pm2`

## Installation Steps

Clone the Onz repository using Git and initialize the modules.

```
git clone https://github.com/OnzCoin/onz.git
cd onz
npm install
```


## Managing Onz

To test that Onz is built and configured correctly, run the following command:

`node app.js`

In a browser navigate to: <http://localhost:11000> (for the mainnet) or <http://localhost:10998> (for the testnet). If Onz is running on a remote system, switch `localhost` for the external IP Address of the machine.

Once the process is verified as running correctly, `CTRL+C` and start the process with `pm2`. This will fork the process into the background and automatically recover the process if it fails.

`pm2 start --name onz app.js`

After the process is started, its runtime status and log location can be retrieved by issuing the following command:

`pm2 show onz`

To stop Onz after it has been started with `pm2`, issue the following command:

`pm2 stop onz`

**NOTE:** The **port**, **address** and **config-path** can be overridden by providing the relevant command switch:

```
pm2 start --name onz app.js -- -p [port] -a [address] -c [config-path]
```

## Tests

Before running any tests, please ensure Onz is configured to run on the same testnet that is used by the test-suite.

Replace **config.json** and **genesisBlock.json** with the corresponding files under the **test** directory:

```
cp test/config.json test/genesisBlock.json .
```

**NOTE:** If the node was started with a different genesis block previous, trauncate the database before running tests.

```
dropdb onz_test
createdb onz_test
```

**NOTE:** The master passphrase for this genesis block is as follows:

```
wagon stock borrow episode laundry kitten salute link globe zero feed marble
```

Launch Onz (runs on port 4000):

```
node app.js
```

Run the test suite:

```
npm test
```

Run individual tests:

```
npm test -- test/lib/accounts.js
npm test -- test/lib/transactions.js
```

## Genesis block
```
dropdb 'onz_test' && dropdb 'onz_main' && createdb 'onz_test' && createdb 'onz_main'
rm -R genesisBlock && mkdir genesisBlock && node tasks/createGenesisBlock.js
mv genesisBlock/genesisBlock.json genesisBlock.json
```

## Authors

- Kan Wong <kan@onzcoin.com>
- Mars Yau <mars@onzcoin.com>
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
