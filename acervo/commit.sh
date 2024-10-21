#!/bin/bash
# Upload files to Github - git@github.com:talesCPV/acervo.git
.git

read -p "Are you sure to commit Acervo to GitHub ? (Y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then

#    cp ~/Documentos/SQL/acervo/*.sql sql/

    git init

    git add assets/
    git add backend/
    git add scripts/
    git add style/
    git add fotos/
    git add vehicles/
    git add index.html
    git add commit.sh
    git add .htaccess
    
    git commit -m "by_script"

    git branch -M main
    git remote add origin git@github.com:talesCPV/acervo.git
    git remote set-url origin git@github.com:talesCPV/acervo.git

    git push -u -f origin main

fi