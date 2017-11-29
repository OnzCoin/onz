const replace = require('replace-in-file');

const options = {
  files: ['../modules/**/*.js'],
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
    files: ['../test/**/*.js'],
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
    files: ['../app.js'],
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
    files: '../README.md',
    from: [
              /Copyright © 2016-2017 Lisk Foundation/g,
              /LiskHQ/g,
              /lisk/g,
              /Lisk/g,
              /LISK/g,
              /onz.io/g,
              /8000/g,
              /7000/g
          ],
    to:   [
              'Copyright © 2017-2018 Onz Coin Foundation',
              'OnzCoin',
              'onz',
              'Onz',
              'ONZ',
              'onzcoin.com',
              '11000',
              '10998'
          ],
};

try {
    const changes = replace.sync(options4);
    console.log('Modified files:', changes.join(', '));
} catch (error) {
    console.error('Error occurred:', error);
}


const options5 = {
    files: ['../helpers/**/*.js'],
    from: [
              /Lisk/g,
              /lisk/g,
              /d121d3abf5425fdc0f161d9ddb32f89b7750b4bdb0bff7d18b191d4b4bafa6d4/g,
              /c96dec3595ff6041c3bd28b76b8cf75dce8225173d1bd00241624ee89b50f2a8/g,
          ],
    to:   [
              'Onz',
              'onz',
              '9ee632b8cc594dc969362dcfbddc458083c4d3ef66de1bf050947a91fe5eff47',
              '62b5193a30bd0e4f78fe77da1bd6ad000a555f1abcfd285ff840a1080fec15ef',
          ],
  };
  
  try {
      const changes = replace.sync(options5);
      console.log('Modified files:', changes.join(', '));
  } catch (error) {
      console.error('Error occurred:', error);
  }



  const options6 = {
    files: ['../Jenkinsfile'],
    from: [
              /Lisk/g,
              /lisk/g
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


  const options7 = {
    files: ['../docs/**/*.js','../logic/**/*.js','../modules/**/*.js','../test/**/*.js'],
    from: [
              /'L'/g
          ],
    to:   [
              '\'Z\''
          ],
  };
  
  try {
      const changes = replace.sync(options7);
      console.log('Modified files:', changes.join(', '));
  } catch (error) {
      console.error('Error occurred:', error);
  }
