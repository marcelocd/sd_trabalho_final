# sd_trabalho_final
Sistema de troca de mensagens entre contatos do SIGAA

Comandos para executar o crawler:

1) Instale ruby:
$ sudo apt install ruby-full

2) Instale a gem nokogiri:
$ gem install nokogiri

3) Execute o arquivo ruby passando como parâmetros nome de usuário e a senha, respectivamente:
$ ruby sigaa_crawler.rb username password

Um arquivo .json com todos os contados da conta em questão será gerado com nome
'username.json' no diretório contacts, que, por sua vez, está no mesmo diretório 
do arquivo sigaa_crawler.rb.