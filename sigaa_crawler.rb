# -------------------------------- *
# Universidade Federal de Goiás    *
# Instituto de Informática         *
# Creation date:   11/14/19        *
# Last updated on: 11/15/19        *
# Author: Marcelo Cardoso Dias     *
# -------------------------------- */

# sigaa_crawler.rb

# REQUIREMENTS -------------------------------
require "byebug"
require "erb"

# --------------------------------------------

# PROBLEM SOLVING FUNCTIONS ------------------
def login username, password
	page = %x[\
		curl -c #{cookies_path()} \
		-b #{cookies_path()} \
		-k --ciphers 'DEFAULT:!DH' \
		"#{login_url()}"
	]

	jsessionid = File.read("#{cookies_path()}").gsub(/[\s]/, ' ').match(/JSESSIONID ([^ ]+)/)[1]

	lt = page.match(/name=\"lt\" value=\"([^\"]+)/)[1]

	execution = page.match(/name=\"execution\" value=\"([^\"]+)/)[1]

	encoded_username = ERB::Util.url_encode(username)

	encoded_password = ERB::Util.url_encode(password)

	form_data = "username=#{encoded_username}&password=#{encoded_password}&lt=#{lt}&execution=#{execution}&_eventId=submit"

	page = %x[
		curl -v -c #{cookies_path()} -b #{cookies_path()} \
		-k --ciphers 'DEFAULT:!DH' \
		-d "#{form_data}" \
		"#{authentication_url1(jsessionid)}" \
		2>&1
	]

	ticket = page.match(/ticket=([^\r]+)/)[1]

	page = %x[\
		curl -c #{cookies_path()} \
		-b #{cookies_path()} \
		-k --ciphers 'DEFAULT:!DH' \
		"#{authentication_url2(ticket)}"
	]

	jsessionid = File.read("#{cookies_path()}").gsub(/[\s]/, ' ').match(/JSESSIONID ([^ ]+) $/)[1]

	page = %x[\
		curl -c #{cookies_path()} \
		-b #{cookies_path()} \
		-k --ciphers 'DEFAULT:!DH' \
		"#{authentication_url3(jsessionid)}"
	]

	page = %x[\
		curl -c #{cookies_path()} \
		-b #{cookies_path()} \
		-k --ciphers 'DEFAULT:!DH' \
		"#{authentication_url4(encoded_username)}"
	]

	page = %x[\
		curl -c #{cookies_path()} \
		-b #{cookies_path()} \
		-k --ciphers 'DEFAULT:!DH' \
		"#{authentication_url5()}"
	]

	page = %x[\
		curl -v -c #{cookies_path()} \
		-b #{cookies_path()} \
		-k --ciphers 'DEFAULT:!DH' \
		"#{authentication_url6()}" \
		2>&1
	]

	ticket = page.match(/ticket=([^\r]+)/)[1]

	page = %x[\
		curl -c #{cookies_path()} \
		-b #{cookies_path()} \
		-k --ciphers 'DEFAULT:!DH' \
		"#{authentication_url7(ticket)}"
	]

	page = %x[\
		curl -c #{cookies_path()} \
		-b #{cookies_path()} \
		-k --ciphers 'DEFAULT:!DH' \
		"#{authentication_url8()}"
	]

	page = %x[\
		curl -c #{cookies_path()} \
		-b #{cookies_path()} \
		-k --ciphers 'DEFAULT:!DH' \
		"#{authentication_url9()}"
	]

	page = %x[\
		curl -c #{cookies_path()} \
		-b #{cookies_path()} \
		-k --ciphers 'DEFAULT:!DH' \
		"#{authentication_url10()}"
	]

	page = %x[\
		curl -c #{cookies_path()} \
		-b #{cookies_path()} \
		-k --ciphers 'DEFAULT:!DH' \
		"#{student_page_url()}"
	]

	save_page(page)
end

# --------------------------------------------

# JSON FUNCIONS ------------------------------
def result_json
	return result_json = {
		contats: []
	}
end

# --------------------------------------------

# PATH FUNCTIONS -----------------------------
def current_path
	return path = %x|pwd|.gsub(/\n/, '') + '/'
end

def page_path
	return current_path + '/'
end

def cookies_path
	return path = current_path() + '/cookies'
end

# --------------------------------------------

# URL FUNCTIONS ------------------------------
def base_url
	return 'https://sigaa.sistemas.ufg.br/sigaa/'
end

def login_url
	return 'https://ufgnet.ufg.br/cas/login?locale=pt_BR&service=https%3A%2F%2Fsigaa.sistemas.ufg.br%2Fsigaa%2FverTelaLogin.do'
end

def authentication_url1 jsessionid
	return "https://ufgnet.ufg.br/cas/login;jsessionid=#{jsessionid}?locale=pt_BR&service=https%3A%2F%2Fsigaa.sistemas.ufg.br%2Fsigaa%2FverTelaLogin.do"
end

def authentication_url2 ticket
	return base_url() + "verTelaLogin.do?ticket=#{ticket}"
end

def authentication_url3 jsessionid
	return base_url() + "verTelaLogin.do;jsessionid=#{jsessionid}"
end

def authentication_url4 encoded_username
	return base_url() + "logar.do?dispatch=logOn&user.login=#{encoded_username}&passaporte=true"
end

def authentication_url5
	return base_url() + 'paginaInicial.do'
end

def authentication_url6
	return 'https://ufgnet.ufg.br/cas/login?locale=pt_BR&service=https%3A%2F%2Fsigaa.sistemas.ufg.br%2Fsigaa%2FpaginaInicial.do'
end

def authentication_url7 ticket
	return base_url() + "paginaInicial.do?ticket=#{ticket}"
end

def authentication_url8
	return base_url() + 'paginaInicial.do'
end

def authentication_url9
	return base_url()+ 'telasPosSelecaoVinculos.jsf'
end

def authentication_url10
	return base_url() + 'verPortalDiscente.do'
end

def student_page_url
	return base_url() + 'portais/discente/discente.jsf'
end

# --------------------------------------------

# SAVING FUNCTIONS ---------------------------
def save_page page
	page_path = current_path() + 'page.html'

	file = File.new(page_path, 'w')
	file.puts page
	file.close
end

# --------------------------------------------

# MAIN ---------------------------------------
def main username, password
	system("rm #{cookies_path}")

	result = result_json()

	login(username, password)
end

# --------------------------------------------
# --------------------------------------------

# TEST ---------------------------------------
username = ARGV.first

password = ARGV[1]

main(username, password)

# --------------------------------------------