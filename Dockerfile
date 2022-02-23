FROM jupyter/scipy-notebook:notebook-6.4.8
USER root

# Allows pyinaturalist version to optionally be set by GitHub Actions
ARG PACKAGE_VERSION='latest'

ENV JUPYTER_SETTINGS="/home/${NB_USER}/.jupyter/lab/user-settings" \
    PATH="/home/${NB_USER}/.local/bin:${PATH}" \
    POETRY_INSTALLER="https://install.python-poetry.org/install-poetry.py" \
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
    'gdal==3.4.1' \
    'geoviews==1.9.4' \
    'geopandas==0.10.2' \
    # Use poetry to install all other packages from lockfile
    && wget $POETRY_INSTALLER \
    && python install-poetry.py -y --version 1.2.0a2 \
    && poetry add "pyinaturalist@${PACKAGE_VERSION}" \
    && poetry install -v \
    # Cleanup
    && poetry cache clear -q --all . \
    && python install-poetry.py --uninstall -y \
    && rm poetry.lock pyproject.toml install-poetry.py \
    && conda clean -yaf || echo 'Failed to clear Conda cache' \
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}"

USER $NB_UID
WORKDIR $HOME
