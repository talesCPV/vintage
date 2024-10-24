/*  DATABASE  */
function queryDB(params,cod){
    let access = -1
    try{
        access = main_data.dashboard.data.access
    }catch{
        access = -1
    }

    const hash = localStorage.getItem('hash') == undefined ? 0 : localStorage.getItem('hash')
    const data = new URLSearchParams()
        data.append("access", access)
        data.append("hash", hash)
        data.append("cod", cod)
        data.append("params", JSON.stringify(params))

    const myRequest = new Request("backend/query_db.php",{
        method : "POST",
        body : data
    });

    return new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) { 
                resolve(response.text())        
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));
            } 
        });
    });      
}


function backFunc(params,cod){
    const data = new URLSearchParams();        
        data.append("cod", cod);
        data.append("params", JSON.stringify(params));        

    const myRequest = new Request("backend/functions.php",{
        method : "POST",
        body : data
    });

    return new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) { 
                resolve(response.text());                    
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));                    
            } 
        });
    });      
}

function getConfig(field){
    const data = new URLSearchParams();        
        data.append("user", localStorage.getItem('id_user'));
        data.append("field", field);
        data.append("file",'config.json');
    const myRequest = new Request("backend/getConfig.php",{
        method : "POST",
        body : data
    });

    return new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) {                 
                resolve(response.text());                    
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));                    
            } 
        });
    }); 
}

function setConfig(field,value){
    const data = new URLSearchParams();        
    data.append("user", localStorage.getItem('id_user'));
    data.append("field", field);
    data.append("file",'config.json');
    data.append("value", value);
    const myRequest = new Request("backend/setConfig.php",{
        method : "POST",
        body : data
    });

    return new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) {                 
                resolve(response.text());                    
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));                    
            } 
        });
    }); 
}

function uploadImage(fileID,path,filename){

    const up_data = new FormData();        
        up_data.append("up_file",  document.getElementById(fileID).files[0]);
        up_data.append("path", path);
        up_data.append("filename", filename);

    const myRequest = new Request("backend/upload.php",{
        method : "POST",
        body : up_data
    });

    const myPromisse = new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) { 
                resolve(response.text());             
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));                    
            } 
        });
    }); 

    return myPromisse
}

    function metadata(path,set=0,value=''){

        const data = new URLSearchParams()
            data.append("path",path)
            data.append("value",value)
            data.append("set",set)
            
        const myRequest = new Request("backend/metadata.php",{
            method : "POST",
            body : data
        })
        const myPromisse = new Promise((resolve,reject) =>{
            fetch(myRequest)
            .then(function (response){
                if (response.status === 200) {
                    resolve(response.text())
                } else {
                    reject(new Error("Houve algum erro na comunicação com o servidor"))
                }
            })
        })
        return myPromisse
    }


function showFiles(path,ext='txt'){

    const data = new URLSearchParams()
        data.append("dir",path)
        data.append("ext",ext)
    const myRequest = new Request("backend/show_dir.php",{
        method : "POST",
        body : data
    })
    const myPromisse = new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) {
                resolve(response.text())
            } else {
                reject(new Error("Houve algum erro na comunicação com o servidor"))
            }
        })
    })
    return myPromisse
      
}

function getFile(path){
    const data = new URLSearchParams();        
        data.append("path", path);
    const myRequest = new Request("backend/loadFile.php",{
        method : "POST",
        body : data
    });

    return new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) {                 
                resolve(response.text());                    
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));                    
            } 
        });
    }); 
}

function getTxt(path){
    const data = new URLSearchParams();        
        data.append("path", path);
    const myRequest = new Request("backend/loadTxt.php",{
        method : "POST",
        body : data
    });

    return new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) {                 
                resolve(response.text());                    
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));                    
            } 
        });
    }); 
}

function renameFile(path,filename){
    const data = new URLSearchParams();        
        data.append("path", path);
        data.append("filename", filename);
    const myRequest = new Request("backend/renameFile.php",{
        method : "POST",
        body : data
    });

    return new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) {                 
                resolve(response.text());                    
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));                    
            } 
        });
    }); 
}

function delFile(path){
    const data = new URLSearchParams();        
        data.append("path", path);
    const myRequest = new Request("backend/delFile.php",{
        method : "POST",
        body : data
    });

    return new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) {                 
                resolve(response.text());                    
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));                    
            } 
        });
    }); 
}

function saveFile(file,path){
    const data = new URLSearchParams();
        data.append("file", JSON.stringify(file));
        data.append("path", path);

    const myRequest = new Request("backend/saveFile.php",{
        method : "POST",
        body : data
    });

    return new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) {                 
                resolve(response.text());                    
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));                    
            } 
        });
    }); 

}

function uploadFile(file,path,filename){

    const up_data = new FormData()
    up_data.append("up_file",  file);
    up_data.append("path", path);
    up_data.append("filename", filename);

    const myRequest = new Request("backend/upload.php",{
        method : "POST",
        body : up_data
    })

    const myPromisse = new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) { 
                resolve(response.text());             
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"))
            } 
        });
    }); 

    return myPromisse
}