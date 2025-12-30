# Build Custom Lib Jars
- **Install Maven**
```bash
sudo apt install maven -y
```
- **Go to `/lib_jars` folder**
- **Check version conflict**
```bash
mvn dependency:tree -Dverbose
```
- **Build Jar files**
```bash
mvn clean package -DskipTests
```