FROM jupyter/scipy-notebook:notebook-7.0.6
USER root

# Allows pyinaturalist version to optionally be set by GitHub Actions
ARG PACKAGE_VERSION='latest'

ENV JUPYTER_SETTINGS="/home/${NB_USER}/.jupyter/lab/user-settings" \
    PATH="/home/${NB_USER}/.local/bin:${PATH}" \
    UV_INSTALLER="https://astral.sh/uv/install.sh" \
    VIRTUAL_ENV="${CONDA_DIR}"
RUN mkdir -p ${JUPYTER_SETTINGS}
COPY user-settings/ ${JUPYTER_SETTINGS}/
COPY uv.lock pyproject.toml ./

# Install utilities for plot & animation rendering
RUN \
    apt-get update \
    && apt-get install -y imagemagick ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN \
    # Use conda to install geospatial libraries (due to binary dependencies)
    conda config --set channel_priority strict \
    && conda install -yq -c conda-forge \
    'gdal==3.10' \
    'geoviews==1.14' \
    'geopandas==1.0' \
    # Use uv to install all other packages from lockfile
    && fix-permissions "/home/${NB_USER}" \
    && curl -LsSf $UV_INSTALLER | sh \
    && uv add "pyinaturalist@${PACKAGE_VERSION}" \
    && uv sync \
    # Cleanup
    && uv cache clean \
    && rm uv.lock pyproject.toml \
    && conda clean -yaf || echo 'Failed to clear Conda cache' \
    && echo 'Fixing permissions' \
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}"

USER $NB_UID
WORKDIR $HOME
