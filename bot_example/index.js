const request = require('request');

setInterval(() => {

  const ACTIONS = {
    'LEFT': 1,
    'RIGHT': 2,
    'DOWN': 3,
    'ROTATE': 4
  };

  let dice = Math.floor(Math.random() * 10);
  let action = 4;
  if (dice < 4) {
    action = 1;
  } else if (dice < 9) {
    action = 2;
  }
  console.log(action);
  request.post(
    'http://127.0.0.1:5000/action',
    {json: { action: action }}
  );
}, 50);

