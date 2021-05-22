FROM docker.io/jupyter/tensorflow-notebook:latest
# See covered packages: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#core-stacks

# Switch to root to allow apt commands
USER root

# Install Debian packages and cleanup afterwards
RUN echo '--- Install Notebook PDF Export Support & Required Compilers' \
&& apt-get update \
&& apt-get install -y --no-install-recommends pandoc texlive-fonts-recommended build-essential \
&& apt-get autoremove -y --purge \
&& apt-get autoclean \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Switch back to standard user of the Jupyter images
USER jovyan

RUN echo '--- Install Basic Data Science Packages' \
&& pip install \
    cython \
    numpy \
    pandas \
    scipy \
    fastparquet \
    feather-format \
    pyarrow \
    tables \
&& rm -rf ~/.cache/pip

RUN echo '--- Install Other Useful Packages' \
&& pip install \
    convertdate \
    lunarcalendar \
    holidays \
    wget \
    xlsx2csv \
    tqdm \
    openpyxl \
    missingno \
    klib \
    pillow \
    chardet \
    tqdm \
&& rm -rf ~/.cache/pip

RUN echo '--- Install Data Viz Packages' \
&& pip install --upgrade \
    dash \
    plotly \
    matplotlib \
    seaborn \
    calmap \
    calplot \
    bokeh \
    holoviews \
    altair \
&& rm -rf ~/.cache/pip

RUN echo "--- Install Missing Tensorflow Packages Causing Error: >> The TensorFlow library was compiled to use FMA instructions, but these aren't available on your machine.<<" \
&& pip install --upgrade \
    tensorflow-gpu  \
&& rm -rf ~/.cache/pip

RUN echo "--- Install Missing Tensorflow Docs" \
&& pip install --upgrade \
    git+https://github.com/tensorflow/docs  \
&& rm -rf ~/.cache/pip  

RUN echo '--- Install Other ML Packages' \
&&  pip install --upgrade \
    mlxtend xgboost rrcf \
&& rm -rf ~/.cache/pip

RUN echo '--- Install Pystan Version Compatible with Prophet' \
&& pip install pystan==2.19.1.1 \
&& rm -rf ~/.cache/pip
# https://facebook.github.io/prophet/docs/installation.html

RUN echo '--- Install Prophet' \
&& pip install --upgrade prophet \
&& rm -rf ~/.cache/pip

RUN echo '--- Install NLP Packages' \
&& pip install --upgrade \
    spacy \
    langdetect \
&& rm -rf ~/.cache/pip
RUN python -m spacy download de_core_news_lg
RUN python -m spacy download de_core_news_sm
RUN python -m spacy download en_core_web_lg
RUN python -m spacy download en_core_web_sm

RUN echo '--- Update JupyterLab to latest' \
&& pip install --upgrade jupyterlab \
&& rm -rf ~/.cache/pip

RUN echo '--- Install JupyText' \
&& pip install jupytext --upgrade \
&& rm -rf ~/.cache/pip

RUN echo '--- Install JupyterLab Extensions' \
&& jupyter labextension install \
    jupyterlab-jupytext \
    jupyterlab-plotly \
    plotlywidget \
    jupyterlab-dash \
    --no-build > /dev/null
    
RUN echo '--- Build JupyterLab Assets (may take several minutes ...)' \
&& jupyter lab build --minimize=False > /dev/null

RUN echo '--- Enable JupyterLab Server Extensions' \
&& jupyter serverextension enable jupytext \
&& echo '--- Disable Token Authentication' \
&& echo "c.NotebookApp.token = ''" > /home/jovyan/.jupyter/jupyter_notebook_config.py \
&& echo "Done."