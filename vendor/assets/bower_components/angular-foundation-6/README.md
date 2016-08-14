# Angular Components for [Foundation](http://foundation.zurb.com/)
***

This project is a port of the AngularUI team's excellent [angular-bootstrap](https://github.com/angular-ui/bootstrap) project for use in the [Foundation](http://foundation.zurb.com/) framework.

[![Build Status](https://travis-ci.org/circlingthesun/angular-foundation-6.svg)](https://travis-ci.org/circlingthesun/angular-foundation-6)

## Demo

Do you want to see this in action? Visit http://circlingthesun.github.io/angular-foundation-6/

## Installation

Installation is easy as angular-foundation-6 has minimal dependencies - only the AngularJS and Foundation's CSS are required.
After downloading dependencies (or better yet, referencing them from your favourite CDN) you need to download build version of this project.

Angular Foundation comes in several flavors:

* `angular-foundation.js` **with** templates
* `angular-foundation-no-tpls.js` **without** templates
* `angular-foundation.min.js` minified **with** templates
* `angular-foundation-no-tpls.min.js` minified **without** templates

When you are done downloading all the dependencies and project files the only remaining part is to add dependencies on the `mm.foundation` AngularJS module:

```javascript
angular.module('myModule', ['mm.foundation']);
```

## Supported Foundation components

* Split Buttons
* Reveal Modal
* Alerts
* Joyride
* Dropdowns
* Tabs
* Offcanvas
* Interchange

We'd gladly accept contributions for any remaining components.

## Supported Browsers

Directives **should** work with the following browsers:

* Chrome (stable and canary channel)
* Firefox
* IE 10 and Edge
* Opera
* Safari

Modern mobile browsers should work without problems.

**IE 8 and 9 are not officially supported.**

## Project philosophy

### Native, lightweight directives

We are aiming at providing a set of AngularJS directives based on Foundation's markup and CSS. The goal is to provide **native AngularJS directives** without any dependency on jQuery or Foundation's JavaScript.
It is often better to rewrite an existing JavaScript code and create a new, pure AngularJS directive. Most of the time the resulting directive is smaller as compared to the orginal JavaScript code size and better integrated into the AngularJS ecosystem.

### Customizability

All the directives in this repository should have their markup externalized as templates (loaded via `templateUrl`). In practice it means that you can **customize directive's markup at will**. One could even imagine providing a non-Foundation version of the templates!

### Take what you need and not more

Each directive has its own AngularJS module without any dependencies on other modules or third-pary JavaScript code. In practice it means that you can **just grab the code for the directives you need** and you are not obliged to drag the whole repository.

### Quality and stability

**Note:** Full test coverage is pending

Directives should work. All the time and in all browsers. This is why all the directives have a comprehensive suite of unit tests. All the automated tests are executed on each checkin in several browsers: Chrome, ChromeCanary, Firefox, Opera, Safari, IE9.
In fact we are fortunate enough to **benefit from the same testing infrastructure as AngularJS**!

## Contributing to the project

We are always looking for the quality contributions! Please check the [CONTRIBUTING.md](CONTRIBUTING.md) for the contribution guidelines.

### Development
#### Prepare your environment
* Install [Node.js](http://nodejs.org/) which should include `npm`
* Install global dev dependencies: `npm install -g gulp`
* Instal local dev dependencies: `npm install` while current directory is foundation repo
* Install test dependencies: `jspm install`

#### Build
* Build the whole project: `gulp` - this will build the project, demo, start a local server on port 8080 and rebuild when code changes are made
* To build modules run `gulp build --modules=module1,module2...:moduleN`

Not specifying any modules will build all modules. Check the `gulpfile.js` file for other tasks that are defined for this project.

#### TDD
* Run test: `gulp watch`

This will start Karma server and will continously watch files in the project, executing tests upon every change.

#### Test coverage
Add the `--coverage` option (e.g. `gulp test --coverage`, `gulp test-legacy --coverage`) to see reports on the test coverage. These coverage reports are found in the coverage folder.

### Customize templates

As mentioned directives from this repository have all the markup externalized in templates. You might want to customize default
templates to match your desired look & feel, add new functionality etc.

The easiest way to override an individual template is to use the `<script>` directive:

```javascript
<script id="src/alert/alert.html" type="text/ng-template">
    <div class='alert' ng-class='type && "alert-" + type'>
        <button ng-show='closeable' type='button' class='close' ng-click='close()'>Close</button>
        <div ng-transclude></div>
    </div>
</script>
```

If you want to override more templates it makes sense to store them as individual files and feed the `$templateCache` from those partials.
For people using Grunt as the build tool it can be easily done using the `grunt-html2js` plugin. You can also configure your own template url.
Let's have a look:

Your own template url is `views/partials/angular-foundation-6-tpls/alert/alert.html`.

Add "html2js" task to your Gruntfile
```
html2js: {
  options: {
    base: '.',
    module: 'ui-templates',
    rename: function (modulePath) {
      var moduleName = modulePath.replace('app/views/partials/angular-foundation-tpls/', '').replace('.html', '');
      return 'template' + '/' + moduleName + '.html';
    }
  },
  main: {
    src: ['app/views/partials/angular-foundation-tpls/**/*.html'],
    dest: '.tmp/ui-templates.js'
  }
}
```

Make sure to load your template.js file
`<script src="/ui-templates.js"></script>`

Inject the `ui-templates` module in your `app.js`
```
angular.module('myApp', [
  'mm.foundation',
  'ui-templates'
]);
```

Then it will work fine!

For more information visit: https://github.com/karlgoldstein/grunt-html2js

### Release
* Bump up version number in `package.json`
* Commit the version change with the following message: `chore(release): [version number]`
* tag
* push changes and a tag (`git push --tags`)
* switch to the `gh-pages` branch: `git checkout gh-pages`
* copy content of the dist folder to the main folder
* Commit the version change with the following message: `chore(release): [version number]`
* push changes
* switch back to the `main branch` and modify `package.json` to bump up version for the next iteration
* commit (`chore(release): starting [version number]`) and push
* publish NPM, Bower and NuGet packages

Well done! (If you don't like repeating yourself open a PR with a gulp task taking care of the above!)

## Credits

Again, many thanks to the AngularUI team for the angular-bootstrap project.
