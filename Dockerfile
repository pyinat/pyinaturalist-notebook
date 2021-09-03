FROM jupyter/scipy-notebook:notebook-6.4.0
USER root

# Allows pyinaturalist version to optionally be set by GitHub Actions
ARG PACKAGE_VERSION='latest'

ENV JUPYTER_SETTINGS="/home/${NB_USER}/.jupyter/lab/user-settings" \
    PATH="/home/${NB_USER}/.local/bin:${PATH}" \
    POETRY_INSTALLER="https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py" \
    POETRY_VIRTUALENVS_CREATE=false \
    VIRTUAL_ENV="${CONDA_DIR}"
RUN mkdir -p ${JUPYTER_SETTINGS}
COPY user-settings/ ${JUPYTER_SETTINGS}/
COPY poetry.lock pyproject.toml ./

# Install utilities for plot & animation rendering
RUN \
    apt update \
    && apt install -y imagemagick ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN \
    # Use conda to install geospatial libraries (due to binary dependencies)
    conda config --set channel_priority strict \
    && conda install -yq -c conda-forge \
    'gdal==3.2.1' \
    'geoviews==1.9.1' \
    'geopandas==0.9.0' \
    # Use poetry to install all other packages from lockfile
    && wget $POETRY_INSTALLER \
    && python install-poetry.py -y \
    && poetry add "pyinaturalist@${PACKAGE_VERSION}" \
    && poetry install -v --no-dev \
    # Cleanup
    && conda clean -yaf \
    && python install-poetry.py --uninstall -y \
    && rm poetry.lock pyproject.toml install-poetry.py \
    && echo 'Fixing file permissions' \
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}"

USER $NB_UID
WORKDIR $HOME
