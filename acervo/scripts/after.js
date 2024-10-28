
real().then((response) => {

    const json = JSON.parse(response)

    const id_acervo = Number(json.id)
    const main_screen = document.querySelector('.vlp-grid')

    document.querySelector('#head-name').innerHTML = json.nome
    document.querySelector('#head-frase').innerHTML = json.frase
    document.querySelector('#fone_1').innerHTML = json.telefone
    document.querySelector('#fone_2').innerHTML = json.telefone
    document.querySelector('#fone_1').href = 'tel:'+json.telefone
    document.querySelector('#fone_2').href = 'tel:'+json.telefone
    document.querySelector('#whats_1').href = 'https://wa.me/55'+getNum(json.whatsapp)

    main_screen.innerHTML = ''
    if (id_acervo) {
        const params = new Object
        params.id_acervo = id_acervo

        queryDB(params, 'VCL-0').then((response) => {
            const json = JSON.parse(response)
            getFile('/../config/settings.json').then((response)=>{
                const url = JSON.parse(response).pastas.save_img
                const logo = window.location+'/../../'+url+'/'+params.id_acervo+'/imagens/logo.jpg'
                const cover = window.location+'/../../'+url+'/'+params.id_acervo+'/imagens/cover.jpg'
                document.querySelector('.home-inv-heading').style['background-image'] = `url(${cover})`
                document.querySelector('#head-logo').src = logo
                for(let i=0; i<json.length; i++){
                    const a =document.createElement('a')
                    a.title = json[i].nome
                    a.alt = json[i].nome
                    a.className = 'worldwide-inventory-item vlp-item'

                    const img = document.createElement('div')
                    img.className = 'vehicle-image lazy'
                    img.style = "background-image: url(assets/pic/no_foto.png)"
                    a.appendChild(img)

                    json[i].path = `${url}/${json[i].id_acervo}/${json[i].id}/imagens/`
                    showFiles(json[i].path,ext='jpg').then((resolve)=>{
                        let has_cover = 0
                        try{
                            has_cover = JSON.parse(resolve).includes('cover.jpg')
                        } catch{
                            null
                        }
                   
                        if(has_cover){
                            img.style = `background-image: url(${window.location}/../../${json[i].path}cover.jpg)`
                        }

                    })

                    const card = document.createElement('div')
                    card.className = 'card-bottom'

                    const ano = document.createElement('div')
                    ano.className = 'year-mk'
                    ano.innerHTML = `${not_null(json[i].ano)} ${not_null(json[i].marca)}`
                    card.appendChild(ano)

                    const modelo = document.createElement('div')
                    modelo.className = 'model'
                    modelo.innerHTML = json[i].nome 
                    card.appendChild(modelo)

                    const desc = document.createElement('div')
                    desc.className = 'default-header'
                    desc.innerHTML = not_null(json[i].descricao)
                    card.appendChild(desc)

                    const price = document.createElement('div')
                    price.className = 'price-stock'
                    price.innerHTML = `<span class='price'>${not_null(json[i].configuracao)} </span>
                                        <span class='stock'>${not_null(json[i].combustivel)} </span>`
                    card.appendChild(price)

                    a.appendChild(card)
                    a.data = json[i]
                    a.addEventListener('click',(e)=>{
                        let div = e.target
                        let i=0
                        while(!div.classList.contains('vlp-item') && i<10){
                            div = div.parentNode
                            i++
                        }
                        if(i<10){
                            document.querySelector('.pop-up').style.display = 'flex'
                            for (var key in div.data) {
                                if (!div.data.hasOwnProperty(key)) continue;
                                const obj = document.querySelector('.about-vcl').querySelector('#vcl-'+key)
                                if(obj != null){
                                    if( ![null,''].includes(div.data[key])){
                                        obj.innerHTML = div.data[key].replaceAll('_',' ')
                                        obj.parentNode.style.display = 'flex'
                                    }else{
                                        obj.parentNode.style.display = 'none'
                                    }
                                    const fds = obj.parentNode.parentNode
                                    const none = fds.querySelectorAll(
                                    'div:not([style*="display:none"]):not([style*="display: none"])'
                                    ).length
                                    fds.style.display = none==0 ? 'none' : 'block'
                                }
                            }

                            queryDB({ id_vcl: div.data.id }, 'VCL-1').then((response) => {
                                const json = JSON.parse(response)
                                const opt = document.querySelector('#vcl-opt')
                                opt.innerHTML = '<legend>Opcionais</legend>'
                                opt.style.display = 'none'
                                for(let i=0; i<json.length;i++){
                                    if(Number(json[i].tem)){
                                        const line = document.createElement('div')
                                        line.className = 'inline'

                                        const txt =  document.createElement('p')
                                        txt.className = 'vcl-text'
                                        txt.innerHTML = json[i].equip
                                        line.appendChild(txt)

                                        opt.appendChild(line)
                                        opt.style.display = 'block'
                                    }
                                }
                            })

                            showFiles(div.data.path,'jpg').then((resolve)=>{
                                const files = JSON.parse(resolve)
                                const carousel = document.querySelector('.carousel')
                                carousel.innerHTML = ''
                                for(let i=2; i<files.length; i++){
                                    const pic = document.createElement('div')
                                    pic.className = 'item-vcl'

                                    const img =  document.createElement('img')
                                    img.className = 'vcl-img'
                                    img.src = window.location+'/../../'+div.data.path+files[i]
                                    pic.appendChild(img)

                                    const shadow = document.createElement('div')
                                    shadow.className = 'vcl-shadow'
                                    pic.appendChild(shadow)

                                    metadata('/../../'+div.data.path+files[i]).then((resolve)=>{
                                        shadow.innerHTML = resolve
                                    })

                                    carousel.appendChild(pic)
                                }
                                carousel.style.transform = `translate3d(0, 0, 0)`
                            })
                        }
                    })
                    main_screen.appendChild(a)
                }
            })
        })
    } else {
        main_screen.innerHTML = 'Página não Encontrada'
    }

})

document.querySelector('.close').addEventListener('click',()=>{
    document.querySelector('.pop-up').style.display = 'none'
})

function go(dir=0){

    const carousel = document.querySelector('.carousel')
    const width = carousel.querySelector('.item-vcl').offsetWidth
    const tot = carousel.querySelectorAll('.item-vcl').length
    const style = window.getComputedStyle(carousel)
    const matrix = new WebKitCSSMatrix(style.transform)
    const pos = matrix.m41 +(width * (dir ? -1 : 1))
    const index = Math.floor(Math.abs(pos)/width)

    if(index < tot && pos <=0 && pos%width == 0){
        carousel.style.transform = `translate3d(${pos}px, 0, 0)`
    }

}

document.querySelector('.go-left').addEventListener('click',()=>{
    go(0)
})

document.querySelector('.go-rigth').addEventListener('click',()=>{
    go(1)
})
