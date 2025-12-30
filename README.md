# Build Custom Lib Jars
- **Install Maven**
```bash
sudo apt install maven -y
```
- **Build Jars files**
```bash
cd lib_jars
mvn clean package -DskipTests
```
- **Copy Jars file**
    - **For `Dev`, `docker compose build` to copy Jars files**
    - **For `Production`, copy to `/usr/lib/flink/lib`**

- **Restart Flink sessions**
```bash
yarn application -kill <APPLICATION_ID>
flink-yarn-session -d -nm "MyFlinkSession" -s 2 -jm 1024m -tm 4096m
```