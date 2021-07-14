FROM jupyter/scipy-notebook:notebook-6.4.0
USER root

# Install packages needed to run all pyinaturalist example notebooks,
# and other packages useful for data exploration & visualization
RUN \
    conda install --quiet --yes \
        altair \
        beautifulsoup4 \
        dash \
        gdal \
        geoviews \
        geopandas \
        openpyxl \
        pillow \
        plotly \
        pyarrow \
        pyinaturalist \
        pytables \
        requests-cache \
        rich \
        tablib[all] \
        unidecode \
        xarray \
        xmltodict \
        'pip>=21' && \
    conda clean --all -f -y && \
    # Install any non-conda pip packages last
    pip install \
        altair-saver \
        gpxpy \
        ipyplot \
        # TODO: Publish pyinaturalist-convert on conda-forge
        pyinaturalist-convert \
        vega-datasets && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

USER $NB_UID
WORKDIR $HOME
