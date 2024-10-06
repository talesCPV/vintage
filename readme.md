<a id="readme-top"></a>

<!-- PROJECT SHIELDS 

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]
-->


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="assets/icons/icon.png">
    <img src="assets/icons/icon.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Plataforma Web/Desktop Planet3</h3>

  <p align="center">
    Modelo padrão da plataforma para aplicações web utilizada pela Planet3 em seus projetos
    <br />
    <a href="#"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://planet3.com.br/modelo/index.html?user=visitante@planet3.com.br&pass=123456" target="_black">View Demo</a>
    ·
    <a href="#">Report Bug</a>
    ·
    <a href="#">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">Sobre o Projeto</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## Sobre O Projeto

<!-- [![Product Name Screen Shot][product-screenshot]](https://example.com) -->

Esta plataforma tem como obetivo montar uma aplicação cliente replicando o estilo "desktop", incluindo desde uma área de trabalho personalizável, onde o usuário poderá trocar seu papel de parede, incluir atalhaos dos módulos do sistema que mais utiliza. Esta área de trabalho também será onde se abrirão as janelas dos módulos do sistema, lembrando em muito um ambiente "Windows". A grande vantagem é a portabilidade do sistema, pois como se trata de uma aplicação web, ele roda completamente no browser do cliente, não necessitando nenhuma instalação prévia na náquina do usuário, virtualizando completamente seu ambiente de trabalho.
Nossa plataforma também é pensada em modo mobile, portanto a informação do cliente estará em suas mãos a um clique de distância
Outra vantagem é o uso de Cloud Computing, onde a grande maioria das transações efetuadas pelo cliente serão executadas em um srvidor na nuvem, não sendo necessário o usio de um grande servidor no cliente e nem máquinas clientes muito poderosas.

Vantagens:
* Sistema Multi Plataforma. Não importa o sistema operacional da máquina cliente, basta um browser com comexão a internet com o JS ligado
* Processamento na Nuvem. Qualquer máquina, por mais antiga que seja, consegue rodar o sistema, já que a grande quantidade de processamento fica a conta do servidor que esta rodando na nuvem
* Mobilidade. Abra o sistema em qualquer lugar, não precisa de instalação nem de servidor no cliente


<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Tecnologias Utilizadas

Totalmente desenvolvido apenas em HTML,CSS e JS no lado cliente e PHP e MYSQL do lado servidor, tecnologias open source, gratuítas e consolidadas no mercado, de fácil desenvolvimento, implementação e manutenção.
Código totalmente organizado em sistema de pastas, utilização de templates HTML, onde cada módulo é desenvolvido e programado separadamente (o código HTML, CSS e JS específico para cada página estão contidas nela), códigos de usu gerais, utilizados em várias paginas, como funções de salvar arquivos, abrir páginas, componentes, etc, estes estão organizados em pastas na raiz do sistema, separados por extenções


<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Como Utilizar


### Pré Requesitos

SERVIDOR: no caso de desenvoilvimento, pode ser um servidor local, como o XAMPP ou LAMPP por exemplo.
BASE DE DADOS: um servidor MySQL ou MariaDB, os scripts para criação das tabelas e procedures basicas estão na pasta SQL

Recomenda-se a utilização do Visual Studio Code, mas pode-se utilizar outra IDE de sua preferência.


### Installation

Para começar um projeto novo é bem simples, basta fazer o download, ou clonar este repositório em uma pasta de um servidor, dando as permissões necessárias.

1. Clone the repo
   ```sh
   git clone https://github.com/talesCPV/plat-3
   ```
2. Dê as permissões necessárias
   ```sh
   sudo chmod 777 *
   ```
3. Crie um novo banco de dados  `MySQL` 
   ```sql
   CREATE DATABASE meu_banco_de_dados;
   ```
4. Rode os scripts tbl.sql e sp.sql dentro do banco criado

5. Altere o arquivo connect.php dentro da pasta backend/ com os dados do seu banco criado
    ```
    $conexao = new mysqli("IP DO BANCO", "USUÁRIO", "SENHA", "NOME DO BANCO");
    ```

6. Acesse a pasta pelo browser:
   ```
    https://localhost/minhapasta
   ```
7. Usuário e senha inicial:
    ```
    usuario: admin@planet3.com.br
    senha: 123456   
    ```

8. Vá no menu Sistema/Permissões, com o botão direito sobre o módulo raiz adicione ou delete os módulos desejados


<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usuários

No menu Sistema/Permissões você pode criar perfis de usuários, os quais você pode liberar acesso aos módulos que este perfil poderá acessar do sistema, estas permissões são dadas com um clique do botão esquerdo do mouse sobre os ítens dos módulos

No Menu Sistema/Usuários você pode criar seus usuários, sempre ligados ua um perfil. O usuário ROOT é o usuário apenas para desenvolvimento, este tem acesso a todos os módulos do sistema, independente de permissões geradas para ele.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP 
## Roadmap

- [x] Add Changelog
- [x] Add back to top links
- [ ] Add Additional Templates w/ Examples
- [ ] Add "components" document to easily copy & paste sections of the readme
- [ ] Multi-language Support
    - [ ] Chinese
    - [ ] Spanish

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

-->

<!-- CONTRIBUTING -->
## Contribuições

Este projeto foi inteiramente criado e desenvolvido por Tales Cembraneli Dantas, https://github.com/talesCPV.

Se você deseja fazer parte deste projeto, por favor entre em contato comigo pelo whatsapp +5512997113793
Obrigado



### 

<a href="https://github.com/talesCPV">

  <img src="https://avatars.githubusercontent.com/u/11446319?v=4" alt="contrib.rocks image" />
</a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Tales Cembraneli Dantas - tales@planet3.com.br

Project Link: <a href="https://github.com/talesCPV/plat-3">PLAT-3</a>

Project DEMO: <a href="https://planet3.com.br/modelo/index.html?user=visitante@planet3.com.br&pass=123456">Clique Aqui!</a> 


<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS 
## Acknowledgments

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!

* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [Malven's Flexbox Cheatsheet](https://flexbox.malven.co/)
* [Malven's Grid Cheatsheet](https://grid.malven.co/)
* [Img Shields](https://shields.io)
* [GitHub Pages](https://pages.github.com)
* [Font Awesome](https://fontawesome.com)
* [React Icons](https://react-icons.github.io/react-icons/search)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

-->

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/othneildrew/Best-README-Template/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/othneildrew/Best-README-Template/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/othneildrew/Best-README-Template/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/othneildrew/Best-README-Template/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/othneildrew
[product-screenshot]: images/screenshot.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
