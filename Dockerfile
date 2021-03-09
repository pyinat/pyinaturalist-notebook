FROM jupyter/scipy-notebook
USER root

# Install some more conda packages useful for data exploration & visualization
RUN \
    conda install --quiet --yes \
        altair \
        beautifulsoup4 \
        dash \
        gdal \
        geoviews \
        geopandas \
        plotly \
        python-dateutil \
        rich \
        requests \
        unidecode \
        vega-datasets \
        xarray \
        'pip>=21' && \
    conda clean --all -f -y && \
    # Install any non-conda pip packages last
    pip install \
        altair-saver \
        gpxpy \
        pyinaturalist \
        requests-cache && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

USER $NB_UID
WORKDIR $HOME
