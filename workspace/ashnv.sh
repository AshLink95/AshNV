if [[ $1 == "build" ]]; then
    docker build -t ashnv ..
elif [[ $1 == "run" ]]; then
    docker run -it --rm -v $(pwd):/workspace -w /workspace ashnv
elif [[ $1 == "del" ]]; then
    docker rmi ashnv
else
    echo "Nada ta da!! either build, run or del"
fi
