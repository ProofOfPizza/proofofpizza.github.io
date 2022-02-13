---
header:
  overlay_image: /assets/images/environments.jpg
  caption: Phenotypic plasticity - The ability of one genotype to produce more than one phenotype when exposed to different environments (Schlichting 1986)
title: "Angular - A minimalistic approach to runtime configurations in docker containers"
categories:
  - tech
  - tutorial
tags:
  - typescript
  - angular
  - devops
  - docker
  - configuration-management
  - coding
  - programming
---
Build your Angular app, run it inside a container and move it across environments. How do we manage our runtime configurations?

Build once, deploy everywhere! This idea relies on the ability to inject configuration settings at runtime. In backend applications there is a way of working for this, and most modern frameworks such as [spring][spring] support these out of the box. They rely on reading environment variables. But what about the frontend, where code is executed in your mom's browser at home and such environment variables are therefore not available? This was my weeks exploration, and is the topic of this blog.

__*Tip: If you like to look at the code while reading along you can [clone the repo][repo].*__

Angular has a nice [system of environments][angular-env] and settings when it comes to build time. You specify the environments you want, and all their settings, and then you build using a flag to build for that environment:
{% include code-header.html %}
```
ng build --configuration production
```

This allows you to create a build for local development, and a different build for the production environment. Things like application urls or database connection strings are almost certainly going to be different for these environments.
Now we can also run a different build for our test, acceptance and staging environments. Problem solved ?
{% include code-header.html %}
```
ng build --configuration test
```
Not quite!

## Build once, deploy everywhere and runtime configs
There are many opinions, and strategies for building applications, making them available on different environments for various types of testing, or production use. Running a new build for each environment is definitely an option,
and I know people who are in favor of that. I disagree. In my opinion and experience it has a few important drawbacks:

- It makes testing results less reliable. "Only config changes, it should work exactly the same". The fact that it *should* work, but actually is *not guaranteed* is why testing is an important effort in software development. So while in a vast majority of cases this is true, once in awhile you encounter unexpected side effects of running a new build.
- It makes the pipelines from local development all the way to production slower. Extra builds means extra time.

There might be more reasons, such as the need to store more artifacts etc, but these would be my most important ones. As said, feel free to disagree with my in the comments or over coffee!
I like the idea of "Run once, build everywhere", also known as [build, release, run][twelve-factor] in the 12-factor app methodology.

So what we need is a way to have different settings available at runtime. For the purpose of this blog I will assume we have an Angular app, that runs inside a docker container, at least on environments other than the local machine.

## Available solutions in Angular
So what are the options we have in angular? Well, surprisingly there is no simple standard way to do this. On the other hand, Angular is a very powerful framework so it is very possible to create solutions with the tools available.
A quick search on the internet will return explanations on how to do that. Most involve more or less the following:
1. Make the configurations available in the `/dist` folder after building without minifying.
2. A javascript function (ususally one of those cute "self invoking" functions) that makes those variables available globally. For Angular, this means setting them on the `window` object.
3. An angular service to read the variables, and this service can then be injected wherever we need access to the variables
4. A way to provide the service and run it's method to load the variables before/while bootstrapping Angular. Usually it involves [APP_INITIALIZER][app-init] and patterns like service factory and service provider.
5. ...some have even more steps for nice things such as custom error handling etc...

Now this is definitely doable, and possibly an elegant solution. However, to me it seems like a lot of boiler plate code, and something as simple as reading some variables there should not be that hard!
<div style="width:100%;height:0;padding-bottom:56%;position:relative;pointer-events:none;"><iframe src="https://giphy.com/embed/XGJqYmrDrmonHAIx0b" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div>

## A minimalistic approach
So in addition to all the previous variations on the solution, I will here offer a different, simple version.
I asked myself _"If I do step 1. and 2. and all variables are available globally, why do we need step 3-x?"_ Well, we do not. We might want to, but we don't need to. So lets look at the first steps and make them as easy as we can.

Let's start by making some config files. We to make these to be available to read and manipulate after compilation. Because we need them to be copied _as-is_ and not compiled and or minified we write them as simple old javascript files. We create a folder `src/config` and in it we create files with some sample configurations:

`config.js`
{% include code-header.html %}
```
__config = {
  apiUrl: 'http://localhost'
}
```
`config.test.js`
{% include code-header.html %}
```
__config = {
  apiUrl: 'https://test.amazing-app.com'
}
```
`config.prod.js`
{% include code-header.html %}
```
__config = {
  apiUrl: 'https://amazing-app.com'
}
```

Next we edit `angular.json` in the project's root folder. It has a section about `assets` under `projects architect build options`, here we specify all files and folders that we want copied as-is to the build output folder (by default: `/dist`). So we make this part look like:
{% include code-header.html %}
```
    "assets": ["src/favicon.ico", "src/assets", "src/config"],
```

To check if all is well so far we run `npm run build` (or `ng build`). We go into the `/dist` folder and next to some minified js files we should find the `assets` folder as well as our new `config` folder with containing the files we just created.

So far so good, time to make them available to us! For this we just use the oldest trick in the javascript book. We load a script in our HTML! So edit `index.html` in our main folder and load the script `<head>` section. It is important to put it there right at the top. The browser will load whatever is in that html file from top to bottom, and we want it to load our settings *before* doing anything with Angular because otherwise our app will not load or work correctly! So go ahead and edit `index.html` to look somewhat like this:
{% include code-header.html %}
```
<!DOCTYPE html>
<html lang="en">
  <head>
    <script src="config/config.js"></script>
    <meta charset="utf-8" />
    <title>ExampleAngularRuntimeConfig</title>
    <base href="/" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="icon" type="image/x-icon" href="favicon.ico" />
  </head>
  <body>
    <app-root></app-root>
  </body>
</html>
```

If we use Angular with typescript we will have to let it know that the variable `__config` exists. We do this by specifying `declare let __config: any;`
This really should be all that is necessary to load your configs at runtime! You can access your `apiUrl` by using `__config.apiUrl`.

*Note: I have seen people use variable name `__env` and claim that it is a **special** variable. It is not. It is just a variable with a funky name. Call it pancakesWithHotsause if you want and you'll see it work as well. The usefulness of starting the variable with __ is mostly to avoid conflicts. It is unlikely, and should be unlikely, that we'll create a variable in our normal code somewhere called __something, so in that way it helps.*


I feel that it might be smart to be a bit more specific about our data structure. If you work together with more people, and or your code grows etc, it is a good practice to use stricter typings to make your code more maintainable.
If you use a code editor that is a bit smart you also get type-ahead support this way. All in all just basic coding hygiene.
If you also feel that way you can go ahead with me and create an interface for the configs/ environment:

`src/app/environment.interface.ts`
{% include code-header.html %}
```
export interface Environment {
  apiUrl: string;
}
```

And we change the `declare` statement to `declare let data: Environment`
If you have cloned the [repo][repo] you will find in `src/app/app.component.ts`:
{% include code-header.html %}
```
declare let data: Environment;

@Component({
  selector: 'app-root',
  template: '<div>{{apiUrl}}</div>',
  styleUrls: ['./app.component.scss'],
})
export class AppComponent {
  apiUrl: string = __config.apiUrl;
}
```

So for now, we do not do anything too complex with our configuration variable, in fact we don't do anything. Just throw it on the screen!

## Running in a docker container and changing the config at runtime
Now we still have a last thing to do and that is to see that we get a feel for how we can change the config at runtime. As far as we have seen now, we have not been changing anything!

For this I will assume we run our app inside of a docker container. Today I will not dive to deep into docker, but just to give a bit of info about the setup in the [repo][repo]:
We have a dockerfile, in our case just the default `Dockerfile`. This is where we specify the build of our app. It is used to build a docker image. That image is what we want to build once, move along all our environments and maybe even ship to customers.

`Dockerfile`
{% include code-header.html %}
```
FROM node:14-alpine as build

# copy code and run build
WORKDIR /app
COPY ./*.json ./
COPY ./src ./src
RUN npm install && npm run build

# run app with nginx
FROM nginx:stable-alpine
COPY --from=build /app/dist/example-angular-runtime-config /usr/share/nginx/html
COPY ./default.conf /etc/nginx/conf.d/default.conf
WORKDIR /start
COPY ./start-app.sh .
CMD [ "sh", "start-app.sh" ]
```


If we take a closer look we see some instructions for a base image, copying files running a build, and then putting the result (everything in `/dist`) inside a nginx folder so it can be served. But where does it take our environment variables into account? In the last step. The `CMD` instruction is where the image receives what is the command to run by default when sinning up a container. In this case, and that is a fairly common pattern it is running a small shell script `start-app.sh`. Lets have a look:
{% include code-header.html %}
```
#/bin/sh
if [ "${ENVIRONMENT}" = "prod" ]
then
  echo "starting app prod"
  mv /usr/share/nginx/html/config/config.prod.js /usr/share/nginx/html/config/config.js
elif [ "${ENVIRONMENT}" = "test" ]
then
  echo "starting app test"
  mv /usr/share/nginx/html/config/config.test.js /usr/share/nginx/html/config/config.js
else
  echo "starting app default / local"
fi
nginx -g "daemon off;"
```

Also pretty straight forward: We check for an environment variable called `ENVIRONMENT` and see if it is either `prod`, `test` or anything else. Then if necessary it overwrites `config.js` with the prod or test version. When that is done it instructs nginx to serve our app. Pretty neat, now let's see it in action!

## Let's build once, and run ...

To build the image run:
{% include code-header.html %}
```
docker build -t amazing-app . # Mind the dot in the end!
```
We have now built the image, and gave it a `tag` _amazing-app_. You can see it by listing the images you now have: `docker image ls`.

Now we want to run a container based on this image, this is our runtime where our configs come into play! The plot thickens!
When you're ready for the magic, run:
{% include code-header.html %}
```
docker run -p 4200:4200 -d --env ENVIRONMENT=local amazing-app
```

This command tells docker to run a container, bind the port 4200 in the container to 4200 on our machine, run in detached mode (so we can easily close it and it does not block our terminal), and pass it an environment variable `ENVIRONMENT=local`. Lastly we specified the image that we want to use to create our container: `amazing-app`.

Now go to your favorite browser and navigate to `http://localhost:4200` and tadaa! Is it not amazing ? Well I am sure you can build even more amazing apps than these, but it does what we want!

Let us stop our container and see some more wonders:
{% include code-header.html %}
```
docker stop $(docker ps -q)
```
This will stop all containers that we have.

Now lets imagine that we were a pipeline and wanted deploy our app to the test environment then we would just use the same image and simply run:
{% include code-header.html %}
```
docker run -p 4200:4200 -d --env ENVIRONMENT=test amazing-app
```
Try it and check your browser! So easy and so powerful!

__*Tip: If you are disappointed, try a hard refresh (shift+F5) or an incognito window!*__

While we know that all out solutions can be useful and have their place, many times a bit more minimalistic solutions are preferable. It keeps our projects small, and easy to maintain. Also adding code when necessary is a normal task that is never forgotten (duh) while removing unnecessary code is much more difficult. So to keep technical debt to a minimum, be sure to avoid over engineering!

I hope you liked this small demo. And if you see anything that could better, or maybe you if just completely disagree with my opinions on devops and _build once, deploy everywhere_ then please feel a warm welcome to leave a comment or reach out!

[repo]: https://github.com/ProofOfPizza/example-angular-runtime-config
[spring]: https://spring.io/
[angular-env]: https://angular.io/guide/build
[twelve-factor]:https://12factor.net/build-release-run
[app-init]: https://angular.io/api/core/APP_INITIALIZER
