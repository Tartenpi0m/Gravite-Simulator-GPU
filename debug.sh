make -C ./Calculateur clean
make -C ./Calculateur compile
./Calculateur/main &
python3.8 Afficheur/main.py
