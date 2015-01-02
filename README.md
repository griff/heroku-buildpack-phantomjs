# Heroku buildpack for PhantomJS

## Usage

```
$ heroku create --stack cedar --buildpack https://github.com/griff/heroku-buildpack-phantomjs.git

# or if your app is already created:
$ heroku config:add BUILDPACK_URL=https://github.com/griff/heroku-buildpack-phantomjs.git

$ git push heroku master
```
