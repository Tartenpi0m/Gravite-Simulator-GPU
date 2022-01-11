#clone gir repo ou copie archive
#rm .git
mkdir data
mkfifo data/py_to_c data/c_to_py
make compile --directory=Calculateur
chmod +x app.sh
