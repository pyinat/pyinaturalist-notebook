# pyinaturalist-notebook
[![Build status](https://github.com/pyinat/pyinaturalist-notebook/actions/workflows/deploy.yml/badge.svg)](https://github.com//pyinat/pyinaturalist-notebook/actions)
[![Docker Image Version](https://img.shields.io/docker/v/jxcook/pyinaturalist-notebook)](https://hub.docker.com/r/jxcook/pyinaturalist-notebook)
[![Run with Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/pyinat/pyinaturalist/main?filepath=examples)

This is an extension of the Jupyter notebook server
([jupyter/scipy-notebook](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-scipy-notebook))
for working with [iNaturalist](https://www.inaturalist.org) data, which adds
[pyinaturalist](https://github.com/pyinat/pyinaturalist) and all dependencies needed for running
[pyinaturalist example notebooks](https://pyinaturalist.readthedocs.io/en/stable/examples.html).

## Usage
```bash
docker pull jxcook/pyinaturalist-notebook
docker run -itd \
    --name jupyter-inat \
    --publish 8888:8888 \
    --volume $(pwd):/home/jovyan/work \
    jxcook/pyinaturalist-notebook

# Show a link to the running notebook, including the access token
docker exec jupyter-inat jupyter notebook list
```

Notes:
* If you use docker-compose, a [`docker-compose.yml`](./docker-compose.yml) file is also included.
* See [Security in the Jupyter notebook server](https://jupyter-notebook.readthedocs.io/en/stable/security.html)
  for options for setting your own token or password.
* See [Running a Container](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/running.html)
  in the Jupyter docs for more general info and examples.

## Links
* [Docker Hub](https://hub.docker.com/r/jxcook/pyinaturalist-notebook)
* [Pyinaturalist repo](https://github.com/pyinat/pyinaturalist)
* [Pyinaturalist documentation](https://pyinaturalist.readthedocs.io)
* [Example notebooks](https://github.com/pyinat/pyinaturalist/tree/main/examples)
