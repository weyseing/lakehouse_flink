# Setup Guide
- **Copy `.env.example` to `.env` & set values**

# Build Custom Lib Jars
- **Install Maven**
```bash
sudo apt install maven -y
```
- **Build Jars files**
```bash
./cli/build_lib_jars.sh
```
- **Copy Jars file & restart Flink session**
    - **For `Dev` environment**
        - `docker compose build` to copy Jars files
        - `docker compose up -d --force-recreate` to restart session
    - **For `Production` environment**
        - Manually copy to `/usr/lib/flink/lib`
        -- Restart Flink session
        ```bash
        ./cli/list_flink_session.sh # check session ID
        yarn application -kill <APPLICATION_ID> # stop session
        ./cli/start_flink_session.sh # recreate session
        ```
        