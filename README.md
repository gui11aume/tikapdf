# Docker container for Tika to convert pdf to text

## Quickstart
The docker image specified in the `Dockerfile` allows you to run
[Apache Tika](https://tika.apache.org/) in a Docker container.

_Note:_ the image is 7.5 GB and it takes more than 30 minutes to
build.

### Clone the repository

Assuming you `git` is installed on your computer, you can clone the repository
with the command below.

```
git clone https://github.com/cellcomplexitylab/tikapdf
```

### Building the image

Change directory to the git repository.

```
cd tikapdf
```

Assuming that `docker` is installed on your computer, you can build the image
with the command below.

```
docker build -t tikapdf:1.0 --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .
```

The image is called `tikapdf` version `1.0` in this example, but you
can replace it with any other name and any other version number. The options
`--build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g)` will allow the
Docker container to create files that are owned by the user building the image.
If those options are left out, the files will be owned by `root`.


## Common running options

### Standard run

Once the image is built, you can convert all the pdf files in the current
directory by running the command below.

```
docker run --rm  -v $(pwd):/share
```

This will create new files, where the extention `.pdf` will be replaced
by `.txt`. If the file already exists, it will be overwritten.

_Explanation of the options:_  
   `--rm`: remove the container upon exit  
   `-v $(pwd):/share`: map the current directory to
`/share` on the virtual machine, where files are written


### Converting specific files

You can convert a list of files of your choice instead of all the files
in the directory. To convert the files `file-1.pdf` and `file-2.pdf`, run
the command below.

```
docker run --rm  -v $(pwd):/share java /bin/pdf2txt.java file-1.pdf file-2.pdf
```

### Printing to `stdout`

You can print the text to `stdout` instead of a local file. To convert
the file `file.pdf` and print the text output to `stdout`, run the command
below.

```
docker run --rm  -v $(pwd):/share java /bin/pdf2txt.java --to-stdout file.pdf
```

## Acknowledgements

This repository is based on the work of [GoldenChrome](https://github.com/goldenchrome).
