/*  DATABASE  */
    function queryDB(params,cod){

        const data = new URLSearchParams()
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

    function real(){
        const url = (window.location).toString().split('/')
        const data = new URLSearchParams()
            data.append("acervo", url[url.length-1])

        const myRequest = new Request("backend/access.php",{
            method : "POST",
            body : data
        })

        const myPromise = new Promise((resolve,reject) =>{
            fetch(myRequest)
            .then(function (response){
                if (response.status === 200) { 
                    resolve(response.text())        
                } else { 
                    reject(new Error("Houve algum erro na comunicação com o servidor"));
                } 
            })
        })
        return myPromise
    }

    function getFile(path){
        const data = new URLSearchParams();        
            data.append("path", path);
        const myRequest = new Request("../backend/loadFile.php",{
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

    function backFunc(params,cod){
        const data = new URLSearchParams();        
            data.append("cod", cod);
            data.append("params", JSON.stringify(params));        
    
        const myRequest = new Request("../backend/functions.php",{
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


function showFiles(path,ext='txt'){

    const data = new URLSearchParams()
        data.append("dir",path)
        data.append("ext",ext)
    const myRequest = new Request("../backend/show_dir.php",{
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