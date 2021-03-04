# iNaturalist Notebook
This is a simple extension of the Jupyter notebook server
([jupyter/scipy-notebook](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-scipy-notebook))
for working with [iNaturalist](https://www.inaturalist.org) data, which adds
[pyinaturalist](https://github.com/niconoe/pyinaturalist) plus some extra packages for data exploration & visualization.

## Usage
```bash
docker pull jwcook9/inaturalist-notebook
docker run -itd \
    --publish 8888:8888 \
    --volume $(pwd):/home/jovyan/work \
    jwcook9/inaturalist-notebook
```

Also see included [`docker-compose.yml`](./docker-compose.yml).

## Links
* [Docker Hub](https://hub.docker.com/repository/docker/jwcook9/inaturalist-notebook)
* [Pyinaturalist repo](https://github.com/niconoe/pyinaturalist)
* [Pyinaturalist documentation](https://pyinaturalist.readthedocs.io)
* [Example notebooks](https://github.com/niconoe/pyinaturalist/tree/master/examples)
