# Setup Guide
- **Git clone from Gitlab**
```bash
# setup credential (use 'gitdeploy' user)
vim ~/.netrc

# git clone
git clone https://git2u.fiuu.com/server/lakehouse/flink.git /lakehouse_flink/
```

- **Update ~/.bashrc based on `Dockerfile`**
- **Copy `.env.example` to `.env` & set values**

# Build Custom Lib Jars
- **Install Maven**
```bash
sudo apt install maven -y
```
- **Build Jars files**
```bash
./build_lib_jars.sh
```
- **Copy Jars file & restart Flink session**
    - **For `Dev` environment**
        - `docker compose build` to copy Jars files
        - `docker compose up -d --force-recreate` to restart session
    - **For `Prod` environment**
        -- Restart Flink session
        ```bash
        ./copy_lib_jars.sh # copy lib jars
        ./list_flink_session.sh # check session ID
        yarn application -kill <APPLICATION_ID> # stop session
        ./start_flink_session.sh # recreate session
        ```
        