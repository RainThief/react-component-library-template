// Whilst this project uses bash and docker for all its utilties, stricly speaking
// you can work with this component library with just nodeModuleNameResolver.js installed.
// Upon yarn or npm install the only thing we can gurantee is that node is installed so this install
// script is written in JavaScript

// using classic js to avoid node module experimental setting
/* eslint-disable @typescript-eslint/no-var-requires */
const fs = require('fs');
const readline = require('readline');
const { exit } = require('process');
const { spawnSync } = require('child_process');
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// is this already a git repo (git cloned)?
const isGit = fs.existsSync('.git') ? true : false;


try {
  let data = JSON.parse(fs.readFileSync('package.json', {
    encoding: 'utf8',
    flag: 'r'
  }));

  // if name not specified in package.json then has not be installed
  // this is a safe check as module cannot be published if name is blank

  if(data.name !== '') {
    process.exit(0);
  }

  gatherInput()
    .then( ({name, git}) => {
      data = {
        ...data,
        name,
      };

      const formatGit = (input) => {
        return input
          .replace(/git\+|\.git/,'')
          .replace(':', '/')
          .replace('git@', 'https://');
      };

      if (isGit) {
        data = {
          ...data,
          repository: {
            ...data.repository,
            url: git
          },
          bugs: {
            ...data.bugs,
            url: formatGit(git)+'/issues'
          },
          homepage: formatGit(git)+'/#readme'
        };
      }

      writeFile(data);
    })
    .catch(error => handleError(error));
}
catch (error) {
  handleError(error);
}


/**
 * Write JSON to text file
 * @param {JSON} data file contents
 */
function writeFile(data) {
  fs.writeFileSync('package.json',
    JSON.stringify(data, null, 2),
    {
      encoding: 'utf8',
    },
    (error) => {
      throw new Error(error);
    }
  );
  process.exit(0);
}


/**
 * List of questions to ask via shell input
 * @return {Promise<Object>} answers to questions
 */
async function gatherInput() {
  return {
    name: await ask('what is your package name'),
    git: (isGit) ? await ask('what is your git repo url', runCmd('git', [
      'remote',
      'get-url',
      'origin'
    ])) : ''
  };
}


/**
 * Ask a question from shell input
 * @param {String} question question text
 * @param {String} [defaultAnswer] prompt with pre-filled answer
 * @return {String} stdout of user input
 */
async function ask(question, defaultAnswer) {
  const defaultAnswerPrompt = (typeof defaultAnswer !== 'undefined') ?  ` (${defaultAnswer})` : '';

  // ask question
  process.stdout.write(`${question}${defaultAnswerPrompt}? `);

  // poll for value response
  const it = rl[Symbol.asyncIterator]();
  const answer = (await it.next()).value;

  // if answer empty and no default set, ask again
  if (typeof defaultAnswer === 'undefined' && answer.trim() === '') {
    return ask(...arguments);
  }

  // if have default set and no answer given , accept default
  if ( answer === '') return defaultAnswer;

  return answer;
}


/**
 * DRY exiting from error state
 * @param {Error} error
 */
function handleError(error) {
  console.error(error.message);
  exit(1);
}


/**
 * Execute commands in shell
 * @param {String} cmd command to execute
 * @param {Array} args command arguments
 * @return {String} command stdout
 * @throws {Error}
 */
function runCmd(cmd, args) {
  const child = spawnSync(cmd, args, {
    stdio: 'pipe',
    shell: true,
    detached: true,
  });

  const stdError = child.stderr.toString();
  if(stdError !== '') {
    throw new Error(stdError);
  }

  return child.stdout.toString().replace(/\n$/, '');
}
