# Dockerfile for Lime Survey
* https://www.d-ip.jp/limesurvey/
* http://donate.limesurvey.org/
* https://www.limesurvey.org/forum
* https://github.com/LimeSurvey/LimeSurvey


## Build
```
docker build . -t hoge/limesurvey
```

or

```
docker build --build-arg URL=<url of source file> . -t hoge/limesurvey
```


## Run

```
docker run -itd --name lime -p 80:80 hoge/limesurvey
```

## Access 

Go to "http://yourwebserver/admin".


## Spec

* Image size : 1.26GB
* Use memory : about 150MB 
