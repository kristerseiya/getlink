# getlink
get linker flags from directories
## example
```bash
/path/to/libtensorflow/lib
├── libtensorflow.1.15.0.dylib
├── libtensorflow.1.dylib -> libtensorflow.1.15.0.dylib
├── libtensorflow.dylib -> libtensorflow.1.dylib
├── libtensorflow_framework.1.15.0.dylib
├── libtensorflow_framework.1.dylib -> libtensorflow_framework.1.15.0.dylib
└── libtensorflow_framework.dylib -> libtensorflow_framework.1.dylib
```
```bash
./getlink.sh /path/to/libtensorflow/lib
```
### Output
```bash
-ltensorflow -ltensorflow_framework
```
## Installation
```bash
echo 'alias getlink=/path/to/getlink.sh' >> .bashrc
```
