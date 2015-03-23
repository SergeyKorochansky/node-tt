Node.js test task
=========

Content
---

- [Demo](#demo)
- [Description](#description)
- [How to run locally](#how-to-run-locally)
- [How to reset database](#how-to-reset-database)
- [Copyright](#copyright)

## Demo

View [demo](https://node-tt.herokuapp.com).

Admin:

Email: ```admin@company.com```

Password: ```123456```

Manager:

Email: ```manager@company.com```

Password: ```123456```

Client:

Email: ```client@company.com```

Password: ```123456```


## Description

This application is uses:

- Platform: Node.js
- Framework: Express.js
- Language: CoffeeScript
- Template Engine: Jade
- Stylesheets preprocessor: LESS
- Databases: Waterline ORM (MongoDB, MySQL)
- Build system: Gulp

## How to run locally

1. Install node.js. You can use [NVM](https://github.com/creationix/nvm)

2. Clone this repository:

    ```
    $ git clone https://github.com/webzepter/node-tt
    ```
3. Change directory to node-tt:

    ```
    $ cd node-tt
    ```
4. Install project dependencies:

    ```
    $ npm install
    ```
5. Run server:

    ```
    $ npm start
    ```

Application will be available at [http://localhost:3000](http://localhost:3000)


## How to reset database

If you need to reset database, run:

```
$ node_modules/.bin/gulp seed
```

## Copyright

This project is released under the MIT license

Copyright (c) 2015 [Serhij Korochanskyj](https://github.com/webzepter).

See [LICENSE.txt](https://github.com/webzepter/node-tt/blob/master/LICENSE.txt) for further details.
