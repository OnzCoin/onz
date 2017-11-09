const replace = require('replace-in-file');

const options = {
  files: ['modules/**/*.js'],
  from: [
            /lisk-sandbox/g,
            /lisk-js-api/g,
            /Lisk/g,

        ],
  to:   [
            'onz-sandbox',
            'onz-js-api',
            'Onz'
        ],
};

try {
    const changes = replace.sync(options);
    console.log('Modified files:', changes.join(', '));
} catch (error) {
    console.error('Error occurred:', error);
}


const options2 = {
    files: ['test/**/*.js'],
    from: [
              /sendLISK/g,
              /randomLISK/g,
              /lisk/g,
              /Lisk/g,
              /LISK/g,
          ],
    to:   [
              'sendONZ',
              'randomONZ',
              'onz',
              'Onz',
              'ONZ'
          ],
  };
  
  try {
      const changes = replace.sync(options2);
      console.log('Modified files:', changes.join(', '));
  } catch (error) {
      console.error('Error occurred:', error);
  }



  const options3 = {
    files: ['app.js'],
    from: [
              /lisk/g,
              /Lisk/g
  
          ],
    to:   [
              'onz',
              'Onz'
          ],
  };
  
  try {
      const changes = replace.sync(options3);
      console.log('Modified files:', changes.join(', '));
  } catch (error) {
      console.error('Error occurred:', error);
  }
  

const options4 = {
    files: 'README.md',
    from: [
              /Copyright © 2016-2017 Lisk Foundation/g,
              /LiskHQ/g,
              /lisk/g,
              /Lisk/g,
              /LISK/g,
          ],
    to:   [
              'Copyright © 2017-2018 Onz Coin Foundation',
              'OnzCoin',
              'onz',
              'Onz',
              'ONZ'
          ],
};

try {
    const changes = replace.sync(options4);
    console.log('Modified files:', changes.join(', '));
} catch (error) {
    console.error('Error occurred:', error);
}


const options5 = {
    files: ['helpers/**/*.js'],
    from: [
              /Lisk/g,
              /lisk/g,
          ],
    to:   [
              'Onz',
              'onz'
          ],
  };
  
  try {
      const changes = replace.sync(options5);
      console.log('Modified files:', changes.join(', '));
  } catch (error) {
      console.error('Error occurred:', error);
  }



  const options6 = {
    files: ['Jenkinsfile'],
    from: [
              /Lisk/g,
              /lisk/g,
          ],
    to:   [
              'Onz',
              'onz'
          ],
  };
  
  try {
      const changes = replace.sync(options6);
      console.log('Modified files:', changes.join(', '));
  } catch (error) {
      console.error('Error occurred:', error);
  }