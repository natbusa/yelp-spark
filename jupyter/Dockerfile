FROM jupyter/pyspark-notebook

# Install Python 3 Tensorflow
RUN conda install --quiet --yes 'tensorflow=1.0*'

# Install Python 2 Tensorflow
RUN conda install --quiet --yes -n python2 'tensorflow=1.0*'

COPY requirements.txt /home/$NB_USER
RUN pip install -r /home/$NB_USER/requirements.txt

COPY datalabframework /home/$NB_USER/datalabframework
RUN pip install /home/$NB_USER/datalabframework

# add the datalabframework extension at startup
COPY ipython_config.py /home/$NB_USER/.ipython/profile_default