function mailsysenvi 
	{
		<#
			.SYNOPSIS
				Envia e-mails com ou sem corpo HTML, suportando múltiplos destinatários e cópias (CC),
				autenticação SMTP e SSL.
			
			.DESCRIPTION
				Esta função permite enviar e-mails de forma programática utilizando um servidor SMTP.
				Ela oferece controle sobre o assunto, corpo do e-mail (lido de um arquivo),
				servidor SMTP, porta, credenciais de autenticação, remetente, múltiplos destinatários
				e cópias (CC). Também inclui uma opção para formatar o corpo do e-mail como HTML.
			
			.PARAMETER mailassunto
				O assunto do e-mail a ser enviado. Este parâmetro é obrigatório.
			
			.PARAMETER mailbodymsg
				O caminho completo para o arquivo de texto que contém o corpo do e-mail.
				O conteúdo deste arquivo será lido e enviado como o corpo da mensagem. Este parâmetro é obrigatório.
			
			.PARAMETER mail_server
				O nome do host ou endereço IP do servidor SMTP a ser utilizado para enviar o e-mail. Este parâmetro é obrigatório.
			
			.PARAMETER mailsrvport
				A porta de conexão do servidor SMTP. Geralmente 587 para TLS/STARTTLS ou 465 para SMTPS (SSL). Este parâmetro é obrigatório.
			
			.PARAMETER mail_sender
				O endereço de e-mail do remetente da mensagem. Este parâmetro é obrigatório.
			
			.PARAMETER mail_authen
				O nome de usuário para autenticação no servidor SMTP, caso seja necessária. Este parâmetro é obrigatório.
			
			.PARAMETER mailenvpass
				A senha do usuário para autenticação no servidor SMTP. Este parâmetro é obrigatório.
			
			.PARAMETER maildestino
				Um array de strings contendo os endereços de e-mail dos destinatários principais.
				Múltiplos endereços podem ser fornecidos. Este parâmetro é obrigatório.
			
			.PARAMETER mailenvcopy
				Um array de strings contendo os endereços de e-mail para cópia (CC).
				Este parâmetro é opcional.
			
			.PARAMETER logs_ashtml
				Um parâmetro switch que, quando presente, indica que o corpo do e-mail deve ser tratado
				como HTML. Isso adiciona as tags de fechamento HTML necessárias ao final do corpo.
				Se omitido, o corpo será tratado como texto simples.
			
			.EXAMPLE
				mailsysenvi -mailassunto "Relatório Diário" -mailbodymsg "C:\Relatorios\relatorio.txt" `
				-mail_server "smtp.seudominio.com" -mailsrvport 587 -mail_sender "remetente@seudominio.com" `
				-mail_authen "usuario_smtp" -mailenvpass "sua_senha" `
				-maildestino "destino1@exemplo.com", "destino2@exemplo.com" -logs_ashtml
			
				Isso enviará um e-mail com o corpo de 'relatorio.txt' formatado como HTML.
			
			.EXAMPLE
				mailsysenvi -mailassunto "Aviso Importante" -mailbodymsg "C:\Mensagens\aviso.txt" `
				-mail_server "192.168.1.10" -mailsrvport 25 -mail_sender "admin@minhaempresa.com" `
				-mail_authen "smtp_user" -mailenvpass "senha123" `
				-maildestino "equipe@minhaempresa.com" -mailenvcopy "gerencia@minhaempresa.com"
			
				Isso enviará um e-mail de texto simples com cópia para a gerência.
				`
			.EXAMPLE 
				Utilizando os parametros como variáveis
				$mail_server = "mail.intus.com.br" 					#NOME OU IP DO SERVIDOR
				$mailsrvport = "587"								#PORTA DE CONEXAO
				$mail_sender = "martinato@intus.com.br"				#REMETENTE DO EMAIL
				$mail_authen = "clientes@intus.com.br"				#E-MAIL PARA AUTENTICACAO
				$mailenvpass = "P05cfRUEtDDS"						#SENHA DO EMAIL PARA AUTENTICACAO DO ENVIO
				$maildestino = "flavio@intus.com.br"				#DESTINATARIO DE EMAIL
				$mailenvcopy = "clientes@intus.com.br"				#CC DO EMAIL
				$mailassunto = "teste de envio com sendmail.exe"	#ASSUNTO DO EMAIL
				$arq_bkp_log = "c:\intus\LOG-TESTE.LOG"				#CAMINNHO COMPLETO DO ARQVUIVO QUE GERARA O CORPO DO EMAIL
							
						mailsysenvi -mailassunto $mailassunto `
									-mailbodymsg $arq_bkp_log `
									-mail_server $mail_server `
									-mailsrvport $mailsrvport `
									-mail_sender $mail_sender `
									-mail_authen $mail_authen `
									-mailenvpass $mailenvpass `
									-maildestino $maildestino `
									-mailenvcopy $mailenvcopy `
									-logs_ashtml
			
			.NOTES
				Desenvolvido por Flavio Galvão
				GitHub: https://github.com/frigerigalvao/funcoes-powershell
				Versão: 1.0
				Data: 2025-06-03
				Licença: MIT License
		#>
		param 
			(
				[string]$mailassunto, 	# Assunto do email
				[string]$mailbodymsg,	# Caminho do arquivo de texto contendo o corpo do email
				[string]$mail_server, 	# Nome ou IP do servidor de email
				[int]$mailsrvport, 		# Porta de conexão
				[string]$mail_sender, 	# Remetente do email
				[string]$mail_authen, 	#usuário para autenticacao do SMTP
				[string]$mailenvpass, 	# Senha do email para autenticação
				[string]$maildestino, 	# Destinatário do email pode ser um array
				[string]$mailenvcopy, 	# CC do email (opcional) pode ser um array
				[switch]$logs_ashtml 	# Adiciona as tags de fechamento HTML se necessário
			)
			
		if ([string]::IsNullOrWhiteSpace($mailassunto) -or 
			[string]::IsNullOrWhiteSpace($mail_server) -or 
			[string]::IsNullOrWhiteSpace($mail_sender) -or 
			[string]::IsNullOrWhiteSpace($mail_authen) -or 
			[string]::IsNullOrWhiteSpace($mailenvpass) -or 
			[string]::IsNullOrWhiteSpace($maildestino))
			{	
				Write-Output "Uma ou mais variáveis estão sem conteúdo válido."
				exit 1
			}
		
		### LÊ O CONTEÚDO DO CORPO DO E-MAIL DO ARQUIVO
		if ([string]::IsNullOrWhiteSpace($mailbodymsg))
			{
				Write-Output "Corpo do e-mail sem conteúdo valido."
				exit 1
			}
		else
			{$mailcontent = Get-Content -Path $mailbodymsg -Raw}
		
		# Adiciona as tags de fechamento HTML se a flag logs_ashtml for verdadeira
		if ($logs_ashtml)
			{$mailcontent += "</font></body></html>" }
		
		#Ajusta certificados
		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		
		Add-Type -AssemblyName System
			
		$smtp_client = New-Object System.Net.Mail.SmtpClient($mail_server, $mailsrvport)
		$smtp_client.EnableSsl = $true
		$smtp_client.Credentials = New-Object System.Net.NetworkCredential($mail_authen, $mailenvpass)

		$mailmessage = New-Object System.Net.Mail.mailmessage
		$mailmessage.From = New-Object System.Net.Mail.MailAddress($mail_sender)
		$mailmessage.To.Add($maildestino)
		if (-not ([string]::IsNullOrEmpty($mailenvcopy))) 
			{$mailmessage.CC.Add($mailenvcopy)}
		$mailmessage.Subject = $mailassunto
		$mailmessage.IsBodyHtml = $logs_ashtml # Define se o corpo é HTML
		$mailmessage.Body = $mailcontent

		$smtp_client.Send($mailmessage)
	}