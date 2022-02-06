DEVICE=$1

if [[ $DEVICE == "GPU" ]]; then
    cuda-memcheck ./Calculateur/GPU/maingpu --show-backtrace &
elif [[ $DEVICE == "CPU" ]]; then
    ./Calculateur/CPU/main &
else
    echo "Parameter should be 'CPU' or 'GPU'"
    exit
fi

python3.8 Afficheur/main.py & >>/dev/null
