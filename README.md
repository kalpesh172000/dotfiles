# welcome to the dotfiles git repo 
This repository contains the dotfiles are saved by kalpesh patil for the use of everyone.
Dotfiles are way to store the importance settings files that we save all the os and software configuration into. Dotfiles makes is easy to relocated or setup the programing evironmnet.
Managing and storing Dotfiles remotely is the we can achive great efficiency in our proffesional work. 

## Working
Dotfiles has two important parts remote storage with github and automatic symbolic link management with stow. 
Stow is the software that creates the symbolic links. Symbolic links create the linkes clone that make file appear in two location in which one is real and other one is link to real one. Because these files are connected changing any one results in change in other one.

First we create a new folder called dotfiles where we would keep the original files. We would move all the files that we need to store here. Now to make use that all he files get symbolic links at the correct location we store the real files with the same file path relative to the home directory. 
for example any file that we want to manage and is currently  stored in $home -> "path-relative-to-home" get stored in "dotfiles/path-relative-to-home" directory 
for example 
    home -> .config -> nvim -> init.lua
    dotfiles -> .config ->nvim ->init.lua

Second we need to create symbolic links. To do that we will use stow. Stow creates and manages symbolic links. Execute following command to track all the added files to the folder.
```
stow . #. stands for create symlinks for all file and subdirectory in current folder. 
```
And finally we create git repo in dotfiles folder and add remote repo to that folder so we can store them remotely. 

## Requirements 

### Git 
install git into the ubuntu by running the following command in the terminal
```
sudo apt install git-all
```

### stow
install stow for creating and managing symbolic link with following command.  
```
sudo apt install stow
```


## Installation

Follow this step by step guide to install all the files onto your computer. 

### Clone Dotfiles 

clone ths repository into your home folder and give it name dotfiles. 
Following commands will take you to home directory and clone this repo in dotfiles directory.
```
cd ~
git clone git@github.com:kalpesh172000/dotfiles.git dotfiles
```
### Take Causion 
Before stowing all the files we would try to find conflicts. It is neccessary as the os and applications create default configuration files and we would try to avoid breaking down any application. 
We can check which files are having conflicts by running 
```
stow --no nvim
```
We can also try to create backup by renaming the files and adding .bak at the end like 
```
mv .zshrc .zshrc.bak
```

### Stow all 
when everything is fine we would create symlinks for all the dotfiles with following command. 
```
cd ~/dotfiles/
stow . 
```
YouTube link to the followed tutorial.
https://youtu.be/y6XCebnB9gs?si=H3_4qH3BfuGxqoKI
