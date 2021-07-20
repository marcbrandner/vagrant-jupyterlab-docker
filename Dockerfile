FROM docker.io/jupyter/base-notebook:python-3.9.5
# See covered packages: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#core-stacks

# Switch to root to allow apt commands
USER root

# Install Debian packages and cleanup afterwards
RUN echo '--- Install Notebook PDF Export Support, required compilers & sudo support' \
&& apt-get update \
&& apt-get install -y --no-install-recommends pandoc texlive-fonts-recommended build-essential sudo \
&& apt-get autoremove -y --purge \
&& apt-get autoclean \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Add user 'jovyan' to sudoers list
RUN echo 'jovyan ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch back to standard user of the Jupyter images
USER jovyan

RUN echo '--- Install Basic Data Science Packages' \
&& pip install --upgrade \
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
&& pip install --upgrade \
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

RUN echo '--- Install Intel-Optimized Tensorflow 2.5.0 if available'
RUN cat /proc/cpuinfo | grep avx2; if [ $? -eq 0 ]; then export TF_ENABLE_ONEDNN_OPTS=1; else export TF_ENABLE_ONEDNN_OPTS=0; fi; \
    pip install "tensorflow==2.5.0" "tensorflow_hub" && rm -rf ~/.cache/pip
# More details:
#   https://software.intel.com/content/www/us/en/develop/articles/intel-optimization-for-tensorflow-installation-guide.html
#   https://unix.stackexchange.com/questions/43539/what-do-the-flags-in-proc-cpuinfo-mean
#   https://www.tensorflow.org/api_docs/python/tf/sysconfig/get_compile_flags

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
RUN python -m spacy download en_core_web_sm
RUN python -m spacy download en_core_web_trf
RUN python -m spacy download de_core_news_sm
RUN python -m spacy download de_dep_news_trf

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