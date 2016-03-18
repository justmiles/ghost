# Ghost
A Hubot implementation


# Development
Ensure the following environment variables are set:
```
  FIREBASE_URL=https://your-firebase-app.firebaseio.com
  FIREBASE_SECRET=xxxxxxxxxxxxxxx
  HUBOT_LOG_LEVEL=debug
  DESTINY_API=xxxxxxxxxxxxxxx
  HUBOT_DISCORD_EMAIL=bot@email.com
  HUBOT_DISCORD_PASSWORD=password
```
Install global dependencies for development
`npm install -g nodemon coffee hubot`

Install local package dependencies
`npm install`

Start hubot in development mode
`npm run dev`
