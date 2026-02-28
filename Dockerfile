FROM quay.io/jupyter/scipy-notebook:latest
USER root

# Allows pyinaturalist version to optionally be set by GitHub Actions
ARG PACKAGE_VERSION='latest'

ENV JUPYTER_SETTINGS="/home/${NB_USER}/.jupyter/lab/user-settings" \
    PATH="/home/${NB_USER}/.local/bin:${PATH}" \
    UV_INSTALLER="https://astral.sh/uv/install.sh" \
    UV_PYTHON="${CONDA_DIR}/bin/python"
RUN mkdir -p ${JUPYTER_SETTINGS}
COPY user-settings/ ${JUPYTER_SETTINGS}/

# Install utilities for plot & animation rendering
RUN \
    apt-get update \
    && apt-get install -y imagemagick ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Use conda to install geospatial libraries (due to binary dependencies)
RUN \
    conda config --set channel_priority strict \
    && conda install -yq -c conda-forge \
    'gdal==3.12' \
    'geoviews==1.15' \
    'geopandas==1.1' \
    && conda clean -yaf || echo 'Failed to clear Conda cache' \
    && fix-permissions "${CONDA_DIR}"

# Install all other packages from lockfile via uv
# uv pip install/sync respects CONDA_PREFIX and installs into the active conda env
COPY uv.lock pyproject.toml ./
RUN \
    fix-permissions "/home/${NB_USER}" \
    && curl -LsSf $UV_INSTALLER | sh \
    && uv export --no-dev --no-emit-project --frozen \
         | uv pip install --python "${CONDA_DIR}/bin/python" -r /dev/stdin \
    && if [ "${PACKAGE_VERSION}" = "latest" ]; then \
         uv pip install --python "${CONDA_DIR}/bin/python" "pyinaturalist"; \
       else \
         uv pip install --python "${CONDA_DIR}/bin/python" "pyinaturalist==${PACKAGE_VERSION}"; \
       fi \
    && uv cache clean \
    && rm uv.lock pyproject.toml \
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}"

USER $NB_UID
WORKDIR $HOME
