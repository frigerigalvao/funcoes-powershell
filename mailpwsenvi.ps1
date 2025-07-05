function mailpwsenvi
	{
		<#
			.SYNOPSIS
				Envia um e-mail através de um servidor SMTP autenticado.
				
			.DESCRIPTION
				Esta função permite enviar e-mails usando um servidor SMTP, com suporte para autenticação,
				conteúdo HTML e cópia (CC). O corpo do e-mail é lido de um arquivo.
				
			.PARAMETER mailassunto
				O assunto do e-mail.
				
			.PARAMETER mailbodymsg
				O caminho completo para o arquivo de texto que contém o corpo do e-mail.
				
			.PARAMETER mail_server
				O nome do host ou endereço IP do servidor SMTP.
				
			.PARAMETER mail_sender
				O endereço de e-mail do remetente.
				
			.PARAMETER mail_authen
				O nome de usuário para autenticação SMTP.
				
			.PARAMETER mailenvpass
				A senha para autenticação SMTP. Atenção: O uso de `-AsPlainText` pode expor a senha em memória.
				
			.PARAMETER maildestino
				Um ou mais endereços de e-mail do destinatário.
				
			.PARAMETER mailenvcopy
				Um endereço de e-mail para cópia (CC). Opcional.
				
			.PARAMETER mailsrvport
				A porta de conexão do servidor SMTP (ex: 587 para TLS/STARTTLS, 465 para SSL).
				
			.PARAMETER logs_ashtml
				Um switch que, quando presente, faz com que o corpo do e-mail seja tratado como HTML
				e adiciona tags de fechamento HTML se necessário.
				
			.EXAMPLE
				# Exemplo de uso básico
				mailpwsenvi -mailassunto "Relatório Diário" `
							-mailbodymsg "C:\Temp\relatorio.html" `
							-mail_server "smtp.example.com" `
							-mail_sender "noreply@example.com" `
							-mail_authen "smtp_user" `
							-mailenvpass "SuaSenhaSegura" `
							-maildestino "admin@example.com" `
							-mailsrvport 587 `
							-logs_ashtml
				
			.EXAMPLE
				# Exemplo com CC e Parâmetros com variáveis e múltiplos destinatários
					$mailassunto = "Notificação de Alerta"
					$arq_stas_hh = "C:\Temp\alerta.txt"
					$mail_server = "smtp.example.com"
					$mailsrvport = 587
					$mail_sender = "alerts@example.com"
					$mail_authen = "smtp_user"
					$mailenvpass = "SuaSenhaSegura"
					$maildestino = @("ops@example.com", "devops@example.com") # Exemplo de array de destinatários
					$mailenvcopy = @("supervisor@example.com") # Exemplo de array de CC

				mailpwsenvi -mailassunto $mailassunto `
							-mailbodymsg $arq_stas_hh `
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
				Requisitos: Parâmetros corretamente informados, acesso ao servidor SMTP 
					usuário e senha de e-mails corretos.
		#>
		param
			(
				[string]$mailassunto, # Assunto do email
				[string]$mailbodymsg, # Caminho do arquivo de texto contendo o corpo do email
				[string]$mail_server, # Nome ou IP do servidor de email
				[string]$mail_sender, # Remetente do email
				[string]$mail_authen, # usuário para autenticacao do SMTP	
				[string]$mailenvpass, # Senha do email para autenticação
				[string]$maildestino, # Destinatário do email 
				[string]$mailenvcopy, # CC do email 
				[int]$mailsrvport, 	  # Porta de conexão
				[switch]$logs_ashtml  # Adiciona as tags de fechamento HTML se necessário e define o corpo como HTML
			)
		
		if ([string]::IsNullOrWhiteSpace($mailassunto) -or
			[string]::IsNullOrWhiteSpace($mail_server) -or
			[string]::IsNullOrWhiteSpace($mail_sender) -or
			[string]::IsNullOrWhiteSpace($mail_authen) -or
			[string]::IsNullOrWhiteSpace($mailenvpass) -or
			[string]::IsNullOrWhiteSpace($maildestino)) 
) 			{
				Write-Output "Uma ou mais variáveis estão sem conteúdo válido."
				exit 1
			}
		### LÊ O CONTEÚDO DO CORPO DO E-MAIL DO ARQUIVO
		if ([string]::IsNullOrWhiteSpace($mailbodymsg))
			{
				Write-Output "Corpo do e-mail sem conteúdo válido."
				exit 1
			}
		else
			{$mailcontent = Get-Content -Path $mailbodymsg -Raw}
		#### ADICIONA AS TAGS DE FECHAMENTO HTML SE A FLAG LOGS_ASHTML FOR VERDADEIRA
		if ($logs_ashtml)
			{$mailcontent += "</font></body></html>" }
			
		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		
		### CRIA UM OBJETO DE CREDENCIAL PARA AUTENTICAÇÃO SMTP
		$credential = New-Object System.Management.Automation.PSCredential($mail_authen,(ConvertTo-SecureString $mailenvpass -AsPlainText -Force))
		$commonsplat = @{
							From		= $mail_sender
							To			= $maildestino
							Subject		= $mailassunto
							Body		= $mailcontent
							SmtpServer	= $mail_server
							Port		= $mailsrvport
							Credential	= $credential
							UseSsl		= $true
							BodyAsHtml	= $logs_ashtml
						}
		if (-not ([string]::IsNullOrEmpty($mailenvcopy))) 
			{$commonsplat.Add("Cc", $mailenvcopy)}
		Send-MailMessage @commonsplat
	}