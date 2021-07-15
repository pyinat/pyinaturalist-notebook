FROM jupyter/scipy-notebook:notebook-6.4.0
USER root

ENV PATH="/home/$NB_USER/.local/bin:$PATH" \
    POETRY_INSTALLER="https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py" \
    POETRY_VIRTUALENVS_CREATE=false \
    VIRTUAL_ENV="$CONDA_DIR"
COPY poetry.lock pyproject.toml ./

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
    && poetry install -v --no-dev \
    # Cleanup
    && conda clean -yaf \
    && python install-poetry.py --uninstall -y \
    && rm poetry.lock pyproject.toml install-poetry.py \
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}"

USER $NB_UID
WORKDIR $HOME
