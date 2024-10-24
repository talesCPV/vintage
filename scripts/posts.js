
function viewPost(start=0,end=0,date=0){

    if(start==end){
        start = main_data.dashboard.data.pos_post
        end = start+10
    }
console.log(start,end)
    const params = new Object;                
    params.date = date ? date : today.getFormatDate()
    params.start = start
    params.end = end
    queryDB(params,'PST-0').then((resolve)=>{
        const json = JSON.parse(resolve)
        main_data.dashboard.data.pos_post += json.length
        console.log(json)
        getPost(json)
    })
}

function setPost(id,txt){
    const params = new Object;                
    params.id = id
    params.texto = txt
    queryDB(params,'PST-1').then((resolve)=>{
        console.log(resolve)
        closeModal('pst_post')
        viewPost()
    })
}

function getPost(json){

    const screen = document.querySelector('#content-screen')
    for(let i=0; i<json.length; i++){
        const post = document.createElement('div')
        post.className = 'post'

        /* HEAD */
        const post_head = document.createElement('div')
        post_head. className = 'post-head'

        // HEAD-LEFT
        const post_head_left = document.createElement('div')
        post_head_left.className = 'post-head-left'

        const post_head_img = document.createElement('img')
        post_head_img.className = 'post-head-img'
        post_head_img.src = 'assets/icons/user_default.png'
        post_head_left.appendChild(post_head_img)

        const post_head_name = document.createElement('div')
        post_head_name.className = 'post-head-name'
        post_head_name.innerHTML = json[i].nome
        post_head_left.appendChild(post_head_name)
        post_head.appendChild(post_head_left)
        
        // HEAD RIGTH
        const post_head_rigth = document.createElement('div')
        post_head_rigth.className = 'post-head-rigth'

        const post_subscribe = document.createElement('div')
        post_subscribe.className = 'post-btn'
        post_subscribe.innerHTML = 'Subscribe'
        post_subscribe.addEventListener('click',()=>{
            console.log(json[i])
        })
        post_head_rigth.appendChild(post_subscribe)
        
        const post_more = document.createElement('div')
        post_more.className = 'btnMore'
        post_more.innerHTML = '...'
        post_more.addEventListener('click',()=>{
            console.log(json[i])
        })
        post_head_rigth.appendChild(post_more)
        post_head.appendChild(post_head_rigth)

        post.appendChild(post_head)
        
        /* POST TEXT */
        const post_text= document.createElement('div')
        post_text.className = 'post-text'
        post_text.innerHTML = json[i].texto.replaceAll('\n','<br>')
        post.appendChild(post_text)

        /* POST TIME */
        const post_time= document.createElement('div')
        post_time.className = 'post-time'
        post_time.innerHTML = `${json[i].hora} ${json[i].mes}-${json[i].dia},${json[i].ano} - ${json[i].views.padStart(3,0)} Views`
        post.appendChild(post_time)

        /* POST SOCIAL */
        const post_social= document.createElement('div')
        post_social.className = 'post-social'

        // MESSAGE
        const post_social_chat= document.createElement('div')
        post_social_chat.className = 'post-social-chat'
        post_social_chat.innerHTML = `<span class="mdi mdi-chat-outline"></span><p>${json[i].messages}</p>`
        post_social.appendChild(post_social_chat)

        // LIKE
        const post_social_like= document.createElement('div')
        post_social_like.className = 'post-social-like'
        post_social_like.innerHTML = `<span class="mdi mdi-thumb-up-outline"></span><p>${json[i].likes}</p>`
        post_social.appendChild(post_social_like)

        post.appendChild(post_social)

        


        screen.prepend(post)
    }




}