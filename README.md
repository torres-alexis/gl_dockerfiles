# gl_dockerfiles
Dockerfiles created for my work at GeneLab

## This branch also acts as a gitpod workspace for running the ERCC analysis as follows:

Open this as a gitpod workspace using this [link](https://gitpod.io/#https://github.com/J-81/gl_dockerfiles/tree/gl_ercc_analysis_v2).

1. Install conda dependencies (using mamba to solve and install faster)
   ``` bash
   conda install -c conda-forge mamba -y
   mamba env update --name base --file /workspace/gl_dockerfiles/assets/conda.yaml
   ```
   > Note: you may get an error about `ModuleNotFoundError: No module named 'conda.cli.main_info'`, this caused no issues in testing this usage.
2. Install R kernel (python kernel will already be available)
   ``` bash
   Rscript -e "IRkernel::installspec()"
   ```
3. Sign the notebook to enable it to run in your browser (Gitpod specific)
    ``` bash
    jupyter trust /workspace/gl_dockerfiles/notebooks/combined_ercc_analysis.ipynb
    ```
4. Run jupyter notebook as follows (Gitpod specific argument)
    ``` bash
    jupyter notebook --ip 0.0.0.0 --no-browser
    ```
5. Open the **last** url in a browser window to access the jupyter notebook
6. All output and inputs are available in the gitpod workspace and can be uploaded/downloaded from there
