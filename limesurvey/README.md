# Lime Survey
* https://www.d-ip.jp/limesurvey/
* http://donate.limesurvey.org/
* https://www.limesurvey.org/forum
* https://github.com/LimeSurvey/LimeSurvey


## Build
```
docker build . -t hoge/limesurvey
```

## Run

```
docker run -itd --name lime -p 80:80 hoge/limesurvey
```

## Access 

Go to "yourwebserver/limesurvey/admin".
