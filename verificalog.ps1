function verificalog 
	{
		<#
		.SYNOPSIS
			Prepara o ambiente de log, criando o diretório de logs se não existir e inicializando ou recriando o arquivo de log.
			Oferece opções para gerar logs em formato HTML e converter o texto para maiúsculas.
		
		.DESCRIPTION
			A função `verificalog` é utilizada para gerenciar a criação e a inicialização de arquivos de log.
			Ela garante que o diretório especificado para os logs exista, criando-o se necessário.
			Em seguida, verifica a existência do arquivo de log: se ele já existir, é removido e recriado; caso contrário, é criado.
		
			Esta função NÃO DEVE ser direcionada diretamente para o arquivo de log.
		
		.PARAMETER logs_folder
			Caminho completo para o diretório onde os arquivos de log serão armazenados.
			Se o diretório não existir, ele será criado.
			
		.PARAMETER arquivo_log
			Nome do arquivo de log a ser criado ou inicializado.
			Se omitido, um nome padrão será gerado (log_YYYY-MM-DD.log)
		
		.PARAMETER logs_ashtml
			Define se os logs serão gerados em formato HTML. Se presente, adiciona tags HTML ao início e ao fim do arquivo de log.
		
		.PARAMETER asuppercase
			Define se o conteúdo das mensagens de log será convertido para letras maiúsculas.
		
		.EXAMPLE
			verificalog -logs_folder "C:\Logs\MinhaAplicacao" -arquivo_log "app.log"
		
			Este exemplo cria o diretório "C:\Logs\MinhaAplicacao" se ele não existir e inicializa o arquivo "app.log" dentro dele.
		
		.EXAMPLE
			verificalog -logs_folder "D:\Logs" -arquivo_log "relatorio.html" -logs_ashtml -asuppercase
		
			Este exemplo cria o diretório "D:\Logs" se necessário, inicializa o arquivo "relatorio.html" em formato HTML,
			e todas as mensagens gravadas serão convertidas para maiúsculas.
		.NOTES
			Desenvolvido por Flavio Galvão
			GitHub: https://github.com/frigerigalvao/funcoes-powershell
			Versão: 1.0
			Data: 2025-06-18
			Licença: MIT License
		#>
		param (
				[string]$logs_folder,
				[string]$arquivo_log,
				[switch]$logs_ashtml,
				[switch]$asuppercase
			  )	
		if ([string]::IsNullOrWhiteSpace($logs_folder)) 
            {
                Write-Output "Falta Parametro: -logs_folder (Caminho completo o diretório de log)"
                exit 1
            }
			
		if ([string]::IsNullOrWhiteSpace($arquivo_log)) 
            {
                $actual_date = Get-Date -Format "yyyy-MM-dd"
				$arquivo_log = "log_$actual_date.log"
            }
		$arquivo_log = Join-Path $logs_folder $arquivo_log
		$stringsaida = ""	
		if (!(Test-Path -Path $logs_folder))
			{
				New-Item -Path $logs_folder -ItemType Directory -ErrorAction Stop | Out-Null
				if($logs_ashtml)
					{$stringsaida = "<html><body><font size=3>Diretório de LOG $logs_folder criado<br>"}
				else
					{$stringsaida = "Diretório de LOG $logs_folder criado.`n"}
			}
		else
			{
				if($logs_ashtml)
					{$stringsaida = "<html><body><font size=3>Diretório de LOG $logs_folder já existe<br>"}
				else
					{$stringsaida = "Diretório de LOG $logs_folder já existe.`n"}
			}
		if (Test-Path $arquivo_log) 
			{
				Remove-Item $arquivo_log 
				if($logs_ashtml)
					{$stringsaida += "Arquivo anterior de LOG $arquivo_log removido.<br>"}
				else
					{$stringsaida += "Arquivo anterior de LOG $arquivo_log removido`n"}
			} 
		else
			{
				if($logs_ashtml)
					{$stringsaida += "Arquivo de LOG $arquivo_log não existe.<br>"}
				else
					{$stringsaida += "Arquivo de LOG $arquivo_log não existe.`n"}
			}
		New-Item -Path $arquivo_log -ItemType File | Out-Null
		if($logs_ashtml)
			{$stringsaida += "Arquivo de LOG $arquivo_log iniciado.<br>"}
		else
			{$stringsaida += "Arquivo de LOG $arquivo_log iniciado.`n"}
		if($asuppercase)
			{$stringsaida = $stringsaida.ToUpper()} 
		Write-Output $stringsaida | add-content -Path $arquivo_log
	}