### Instructions

1. Pull the Docker image:
   ```
   docker pull quay.io/nasa_genelab/gl4u:GL4U_Intro_2024_SMCE
   ```

2. Run the Docker container and expose port 8888:
   ```
   docker run -p 8888:8888 quay.io/nasa_genelab/gl4u:GL4U_Intro_2024_SMCE
   ```

3. Once the container is running, you should see a terminal prompt with the conda environment activated, like this:
   ```
   (gl4u_intro_2024) jovyan@6eb77d0ef4c1:/workspace$
   ```

4. In the terminal, run the following command to start Jupyter Lab:
   ```
   jupyter lab
   ```

5. You'll see a URL with a token in your terminal. It should look something like this:
   ```
   http://127.0.0.1:8888/lab?token=<your_token>
   ```

6. Hold Ctrl (or Cmd on Mac) and click on the URL to open it directly in your web browser.

7. You should now see the Jupyter Lab interface.
