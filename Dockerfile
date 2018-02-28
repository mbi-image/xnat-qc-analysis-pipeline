FROM monashbiomedicalimaging/nianalysis

# Add docker user
RUN useradd -ms /bin/bash docker
USER docker
ENV HOME=/home/docker
ENV WORK_DIR $HOME/work-dir 

RUN mkdir -p $WORK_DIR 

# Create symlink to credentials directory which should be mounted at runtime
RUN ln -s $HOME/credentials/netrc $HOME/.netrc

# Set up bashrc and vimrc for debugging
RUN sed 's/#force_color_prompt/force_color_prompt/' $HOME/.bashrc > $HOME/tmp; mv $HOME/tmp $HOME/.bashrc;
RUN echo "set background=dark" >> $HOME/.vimrc
RUN echo "syntax on" >> $HOME/.vimrc
RUN echo "set number" >> $HOME/.vimrc
RUN echo "set autoindent" >> $HOME/.vimrc

# Download QA script to run
RUN echo "BUILD 4"
RUN git clone https://github.com/mbi-image/xnat-nif-qc-analysis.git $HOME/repo
ENV PYTHONPATH $HOME/repo:$PYTHONPATH
ENV PATH $HOME/repo/scripts:$PATH
WORKDIR $HOME

# XNAT container pipeline label
LABEL org.nrg.commands="[{\"index\": null, \"working-directory\": null, \"description\": \"Analyses QC sessions acquired as per the NIF TDRS SOP\", \"command-line\": \"pipeline_cmd.sh #SESSION# #T1# #T2# #DMRI#\", \"inputs\": [{\"command-line-flag\": null, \"name\": \"T1 32Ch Scan Name\", \"default-value\": \"\", \"matcher\": null, \"false-value\": null, \"required\": true, \"true-value\": null, \"replacement-key\": \"#T1#\", \"command-line-separator\": null, \"type\": \"string\", \"description\": \"Name of the T1-weighted saline phantom with 32 Channel Head Coil\"}, {\"command-line-flag\": null, \"name\": \"T2 32Ch Scan Name\", \"default-value\": \"\", \"matcher\": null, \"false-value\": null, \"required\": true, \"true-value\": null, \"replacement-key\": \"#T2#\", \"command-line-separator\": null, \"type\": \"string\", \"description\": \"Name of the T2-weighted saline phantom with 32 Channel Head Coil\"}, {\"command-line-flag\": null, \"name\": \"dMRI 32Ch Scan Name\", \"default-value\": \"\", \"matcher\": null, \"false-value\": null, \"required\": true, \"true-value\": null, \"replacement-key\": \"#DMRI#\", \"command-line-separator\": null, \"type\": \"string\", \"description\": \"Name of the Diffusion MRI saline phantom with 32 Channel Head Coil\"}], \"outputs\": [], \"image\": \"monashbiomedicalimaging/xnat-nif-qc-analysis\", \"label\": null, \"version\": \"1.0\", \"info-url\": null, \"xnat\": [{\"derived-inputs\": [], \"contexts\": [\"xnat:imageSessionData\"], \"description\": \"Analyses QC sessions acquired as per the NIF TDRS SOP\", \"output-handlers\": [], \"external-inputs\": [{\"name\": \"session\", \"load-children\": false, \"required\": true, \"replacement-key\": \"#SESSION#\", \"type\": \"Session\", \"description\": \"Input session\"}], \"name\": \"QC Analysis\"}], \"schema-version\": \"1.0\", \"environment-variables\": {}, \"type\": \"docker\", \"ports\": {}, \"name\": \"QC Analysis\"}]"
