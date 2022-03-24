## install latest gitlab runner over instance 

navigate over repository settings --> cicd --> runner --> 

1. ssh into instance run command

```
gitlab-runner register 

```
then copy instance url from gitlab  and token and select docker and setup config.toml file by default it will be /etc/gitlab-runner/config.toml
/srv/gitlab-runner/config/config.toml in case of gitlab runner in docker.


