---
title: "How to use keepass programmatically with typescript"
categories:
  - tech
  - tutorial
tags:
  - coding
  - programming
  - typescript
  - keepass
  - testing
---
Even though we all know keeping user credentials in our code is bad (right ?) ... sometimes it still happens. For instance when we write our automated tests, and then it "does not really matter that much because it is just the test environment". Well it might not, if everyone else (sysadmins etc) are doing their work correctly. But why gamble? It's 2022 folks, security is a shared responsability these days, and there are tons of tools to help us at any level.

So today let's look at a great example of these tools: [keepass][keepass]. It is a tool that allows you to generate strong passwords, store them securely in an encrypted database (a .kdbx file), and retrieve them quickly and easily. You only need to remember one master password. There are many apps out there for mac, windows, linux and mobile devices that can offer even more features such as autofill passwords in your browser etc. And then sharing your passwords is easy with something like [nextcloud][nextcloud] or even just plain old emails (but this gets you in a hell of versions obviously). For teams working with or on the same app you can store them in AWS, GCS, or Azure, and then set IAM permissions so you have fine grained control over them.

All of that is great but it gets better: We can also use keepass programmatically. This way we can have our code open up the database, and extract the users credentials and run our tests for example. This means that we can store the database with test users in git (because it is safely encrypted), and all we need to do is pass a master password. The easiest way to do that is through an environment variable (or shell variable). That way if we run it locally we can just pass it in from the command line (or possible our IDE). When we run it for instance in a pipeline, we can tell the pipeline to fetch the master password from a secure place (for instance: the pipeline will have an IAM role with a policy that allows it to retrieve secrets from [AWS secrets manager][secretsmanager])

Here is an example for typescript. You can find it on [github][github] We can use a [keepass.io][kpio] library for this. In this small example I have an `app.ts` file which imports a `keepass.ts` file where we do all the magic with our database. Imagine the `app.ts` file could be anything like a module handles logging in to our app for instance.

To get started we need to make an encrypted database. For this we install our favourite keepass app, and open it. Choose new to create a new database file, and choose your database name. I chose `users`. Then we can fill in a few users. I filled in:
````
admin_user@my-app.com
normal_user1@my-app.com
normal_user2@my-app.com
````
We'll let keepass generate some nice strong passwords for us and save.

Then we install keepass.io with `npm install --save keepass.io`. Now this might give you a screen full of errors about python missing... but then they lovingly reassure us:

> DO NOT WORRY ABOUT THESE MESSAGES. KEEPASS.IO WILL FALLBACK TO SLOWER NODE.JS METHODS, SO THERE ARE NO LIMITATIONS EXCEPT SLOWER PERFORMANCE.

If we worry about performance, we should make sure to have a working installation of python available. But then again, in most real world scenarios this is not the place where your performance bottleneck is at.
Ok, then to start using we import it at the top `const kpio = require('keepass.io')` and we're ready to go!

We define a class `Keepass` and in it one method called `getPassword`. Obviously you can add other methods as well if needed: keepass.io also supports writing to the database etc. But for our simple purposes we just want to retrieve a password to then use it for other great things.

In `getPassword` we first open the database with the master password and retrieve it's contents with `getRawApi`.
```
      let db = new kpio.Database();
      db.addCredential(new kpio.Credentials.Password(masterpass));
      db.loadFile(dbPath, function (err: any) {
        if (err) reject(err);
        const rawDb = db.getRawApi().get();
        [...]
      })
```

`getRawApi.get()` return the contents of the database as javascript Object. If we add a `console.log(rawDb)` we see something like:

```
{
  KeePassFile: {
    Meta: {
      Generator: 'KeePass',
      HeaderHash: '9ky87SMwixNRtGVl9TvG0VSzyawLmT9hpAbl8Z2ev1o=',
      DatabaseName: 'users',
      DatabaseNameChanged: '2022-01-24T06:31:05Z',
      DatabaseDescription: '',
      DatabaseDescriptionChanged: '2022-01-24T06:30:53Z',
      DefaultUserName: '',
      DefaultUserNameChanged: '2022-01-24T06:30:53Z',
      MaintenanceHistoryDays: '365',
      Color: '',
      MasterKeyChanged: '2022-01-24T06:30:53Z',
      MasterKeyChangeRec: '-1',
      MasterKeyChangeForce: '-1',
      MemoryProtection: [Object],
      RecycleBinEnabled: 'True',
      RecycleBinUUID: 'uWPZ1nyGcEyuvZyvRSLLnA==',
      RecycleBinChanged: '2022-01-24T06:30:53Z',
      EntryTemplatesGroup: 'AAAAAAAAAAAAAAAAAAAAAA==',
      EntryTemplatesGroupChanged: '2022-01-24T06:30:53Z',
      HistoryMaxItems: '10',
      HistoryMaxSize: '6291456',
      LastSelectedGroup: 'YWA8EJj7aUaHuop6TkTKGQ==',
      LastTopVisibleGroup: 'YWA8EJj7aUaHuop6TkTKGQ==',
      Binaries: '',
      CustomData: ''
    },
    Root: { Group: [Object], DeletedObjects: '' }
  }
}
```

As we see there is a lot of meta data about our database here, but the real magic sits inside the `Root` node. From there we can drill down, and we see that inside `rawDb["KeePassFile"]["Root"]["Group"]["Entry"]` we have an array with a bunch of things amongst which a node `String` that contains an array of objects. Inspecting one of those by logging `rawDb["KeePassFile"]["Root"]["Group"]["Entry"][0]["String"]`:

```
[
  { Key: 'Notes', Value: '' },
  {
    Key: 'Password',
    Value: { _: 'AO01ylqPyTycqOCOREBz', '$': [Object] }
  },
  { Key: 'Title', Value: 'admin' },
  { Key: 'URL', Value: '' },
  { Key: 'UserName', Value: 'admin_user@my-app.com' }
]
The credentials for adminUser are: admin_user@my-app.com / AO01ylqPyTycqOCOREBz
[
  { Key: 'Notes', Value: '' },
  {
    Key: 'Password',
    Value: { _: 'AO01ylqPyTycqOCOREBz', '$': [Object] }
  },
  { Key: 'Title', Value: 'admin' },
  { Key: 'URL', Value: '' },
  { Key: 'UserName', Value: 'admin_user@my-app.com' }
]
The credentials for normalUser1 are: normal_user1@my-app.com / Mv2j8EHTbSnSTphBWHey
[
  { Key: 'Notes', Value: '' },
  {
    Key: 'Password',
    Value: { _: 'AO01ylqPyTycqOCOREBz', '$': [Object] }
  },
  { Key: 'Title', Value: 'admin' },
  { Key: 'URL', Value: '' },
  { Key: 'UserName', Value: 'admin_user@my-app.com' }
]
```

This has all the info we actually need. If you added a title you will find it here, as well as notes or any other fields you used. So looping through this array, and matching it against the requested userName, will gives us what we need.

The total then looks something like this:

```
const kpio = require("keepass.io");

const dbPath = "./users.kdbx";
const masterpass = process.env["KEEPASS_PW"];

class Keepass {
  getPassword = async (userName: string): Promise<string> => {
    return new Promise((resolve, reject) => {
      let db = new kpio.Database();
      db.addCredential(new kpio.Credentials.Password(masterpass));
      db.loadFile(dbPath, function (err: any) {
        if (err) reject(err);
        const rawDb = db.getRawApi().get();
        const entries = rawDb["KeePassFile"]["Root"]["Group"]["Entry"].map(
          (x: any) => x["String"]
        );
        const secrets = entries.map((entry: any) => {
          const userName = entry.find((x: any) => x["Key"] === "UserName")[
            "Value"
          ];
          const password = entry.find((x: any) => x["Key"] === "Password")[
            "Value"
          ]["_"];
          return {
            userName,
            password,
          };
        });
        const returnValue = secrets.find((s: any) => s.userName === userName)
          ?.password;
        resolve(returnValue);
      });
    });
  };
}
```

If you want to see it work then run:

```
git clone git@github.com:ProofOfPizza/example-keepass-and-typescript.git
npm install
tsc
KEEPASS_PW=super-secret12#$ npm start
```

As you see, it is quite easy to use keepass in your code and increase security when it comes to user credentials.
Happy coding and let me know what you think!

[keepass]: https://keepass.info/
[kpio]: https://github.com/SnapServ/keepass.io
[nextcloud]: https://nextcloud.com
[github]: https://github.com/ProofOfPizza/example-keepass-and-typescript
[secretsmanager]: https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html
