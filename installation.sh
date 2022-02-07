pip install pygame
mkdir data
mkfifo data/py_to_c data/c_to_py
make compile --directory=Calculateur/GPU
make compile --directory=Calculateur/CPU
chmod +x app.sh

export CUDA_HOME=/usr/local/cuda/

echo -e "\e[0;32mInstallation finis"
echo -e "\e[0;31mSi vous n'etes pas developpeur, vous pouvez supprimer le code source et le fichier .git"
echo "Si vous ne savez pas de quoi il s'agit, pressez 'n' ou la touche 'entrer'"
echo "Voulez vous les supprimer (y/n) : "
read -r CHOICE
if [[ $CHOICE == 'y' ]]; then
	rm Calculateur/GPU/*.c* -fv
	rm Calculateur/GPU/*.h -fv
	rm Calculateur/CPU/*.c -fv
	rm Calculateur/CPU/*.h -fv
fi
