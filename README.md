# 31T Static

## Creating new events

### Create new server instance
Follow the instructions on the README of the `31tAPI` repo.

### Update the "auto redirect" config
This is so that `http://app.31t.org` will redirect to the latest event, eg.:
`http://app.31t.org/#YYMMDD`.

- Open the file `src/_includes/head.html`
- Modify the `LATEST_31T_EVENT` global var, it should be in a script tag like:
	- ```
	<script>
		window.Polymer = window.Polymer || {};
		window.Polymer.dom = 'shadow';
		window._ENV = "{{jekyll.environment}}";
		window.LATEST_31T_EVENT = 'YYMMDD';
	</script>
	```

### Deploy

#### Dependencies
- Node 8 (needs to be 8!): `nvm use 8`
- Jekyll 3 (needs to be 3!): `gem install jekyll --version 3.0.0`

#### Deploy to stage and test
```
nvm use 8
npm run gulp -- deploy --environment=stage
```

Navigate to `http://app-stage.31t.org/` and see if the redirect happens.

#### Deploy to production
```
nvm use 8
npm run gulp -- deploy --environment=production
```

### If the upload fails
If uploading all the images fail, better to upload them manually in S3.
---------------------------------------

# Instructions to run the event
- System preferences >> Energy saver >> Turn display off = NEVER
- Run on Google Chrome Browser
- Connect computer to power supply
- Open the tabs bellow
- Have you browser on fullscreen

#### Tab 1: Intro
https://docs.google.com/presentation/d/XXXXXXXXXXXXX

- Press `Shift` + `Cmd` + `Return` to start presentation from beginning
- Press `Opt` + `Cmd` + `->` to switch to the next tab

#### Tab 2: Live
http://app.31t.org/live-combinations/?title=31T&interval=12#YYMMDD

- Press `Opt` + `Cmd` + `->` to switch to the next tab

#### Tab 3: Compilation
http://app.31t.org/live-combinations/?title=31T&interval=3&created=0#YYMMDD

- Press `Cmd` + `R` to refresh

----------------------------------------

# URLS

#### App:
http://app.31t.org/YYMMDD

#### Projection (Live):
http://app.31t.org/live-combinations/?title=31T&interval=20#YYMMDD

#### Projection (Only best combinations):
http://app.31t.org/live-combinations/?title=31T&interval=20&created=0&rating=4,5&loop=true#YYMMDD

#### Compilation:
http://app.31t.org/live-combinations/?title=31T&interval=3&created=0#YYMMDD

----------------------------------------
## Dependecies
- Nodejs
- Npm
- Bower
- Jekyll

## Setup
```
git clone https://github.com/oakwood/31TStatic.git
cd 31TStatic
npm install
bower install
```
## Distribution Setups
There are different distribution "setups". All setups have the same content, but each one have a difference in how the content get piped before being deployed to the final distribution directory.
- `dev`
- `polymer`
- `gzip`

#### `dev` distribution
It's the content of `/src` compiled with Jekyll.

The final content get's deployed to `/dist_dev`.

#### `polymer` distribution
Same as `dev`, but the content also needs to pass through a JSLint test first, and afterwards, the main Polymer resources (`/src/assets/elements/elements.html`) gets "polybuilt" to `/src/assets/elements/elements.build.html` and `/src/assets/elements/elements.build.js`. Service worker elements also get placed in the correct paths, and paths are updated to use minified resources.

The final content get's deployed to `/dist_polymer`.

#### `gzip` distribution
Same as `polymer`, but the content is gzipped afterwards.

The final content get's deployed to `/dist_gzip`.

## Command line interface
Every distribution setup respond to the same set of command line tasks:
- `build`
- `serve`
- `watch`
- `clean`

#### `npm run gulp -- build:{distribution}` task
Builds the content of the `/src` to one of the distribution directories.
- `npm run gulp -- build:dev` (builds to `/dist`)
- `npm run gulp -- build:polymer` (builds to `/dist_polymer`)
- `npm run gulp -- build:gzip` (builds to `/dist_gzip`)

#### `npm run gulp -- serve:{distribution}` task
Serves the content of the distribution directory.
- `npm run gulp -- serve:dev` (serves at http://localhost:5500)
- `npm run gulp -- serve:polymer` (serves at http://localhost:5501)
- `npm run gulp -- serve:gzip` (serves at http://localhost:5502)

#### `npm run gulp -- watch:{distribution}` task
Serves the content of the distribution directory and rebuilds every time there is a file change.

#### `npm run gulp -- clean:{distribution}` task
Cleans the content of the distribution directory.

## Environment flags
All the command line task accepts a `--environment` flag. This flag will be used internally by Jerkyll to enable/disable features and also to control environment specific settings (@see `/src/_config.yml`).

There are 3 possible values for the flags
- `--environment=development` (default)
- `--environment=production`
- `--environment=stage`

Sample usage
```
npm run gulp -- build:dev --environment=production
npm run gulp -- serve:polymer --environment=stage

# no flag...
npm run gulp -- watch:gzip
# ...same as:
npm run gulp -- watch:gzip --environment=development
```
## Deploying
To deploy the `gzip` setup to Amazon S3, please create the corresponding configuration
files in `/aws-config/[environment].json`.
For security, those files should not be included on the repository.

Examples:

### `/aws-config/stage.json`

```
{
  "key": "YOUR_S3_KEY",
  "secret": "YOUR_S3_SECRET",
  "bucket": "yourbucket-stage.com",
  "region": "us-east-1"
}

```
### `/aws-config/production.json`

```
{
  "key": "YOUR_S3_KEY",
  "secret": "YOUR_S3_SECRET",
  "bucket": "yourbucket.com",
  "region": "us-east-1"
}

```

When you are ready to deploy, run:
```
npm run gulp -- deploy --environment=stage
```
or
```
npm run gulp -- deploy --environment=production
```
## Updating dependencies

### Bower
The bower dependencies are intentionally locked to avoid surprises, but it's recommended that you keep them updated - you will just have to do it manually, one by one.

In order to make your life easier, use `npm-check-updates`.

```
npm install -g npm-check-updates
ncu -m bower
```
