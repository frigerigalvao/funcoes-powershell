function verificadir
	{
		<#
			.SYNOPSIS
				Verifica a existência de um diretório e o cria se não existir.
	
			.DESCRIPTION
				Esta função verifica se um diretório especificado já existe no sistema.
				Se o diretório não for encontrado, a função tentará criá-lo.
				Ela também oferece opções para formatar a saída, como gerar em HTML ou converter para letras maiúsculas.
	
			.PARAMETER dirtocreate
				O caminho completo do diretório a ser verificado e, se necessário, criado.
				Este parâmetro é obrigatório.
	
			.PARAMETER logs_ashtml
				Um switch que, se presente, adiciona uma quebra de linha HTML (<br>) à mensagem de saída.
				Útil quando a saída será renderizada em um contexto HTML.
	
			.PARAMETER asuppercase
				Um switch que, se presente, converte toda a mensagem de saída para letras maiúsculas.
				
			.PARAMETER del_old_dir
				Um switch que, se presente, remove o diretório $dirtocreate se existir e depois cria o mesmo vazio.
	
			.EXAMPLE
				verificadir -dirtocreate "C:\NovoDiretorio"
				Cria "C:\NovoDiretorio" se não existir.
	
			.EXAMPLE
				verificadir -dirtocreate "D:\MeusDocs" -asuppercase
				Verifica "D:\MeusDocs" e exibe a mensagem de saída em maiúsculas.
	
			.EXAMPLE
				verificadir -dirtocreate "E:\WebLogs" -logs_ashtml
				Verifica "E:\WebLogs" e formata a saída com uma quebra de linha HTML.
	
			.NOTES
				Desenvolvido por Flavio Galvão
				GitHub: https://github.com/frigerigalvao/funcoes-powershell
				Versão: 1.0
				Data: 2025-06-18
				Licença: MIT License
		#>
        param (
                [Parameter(Mandatory=$true)]
                    [string]$dirtocreate,
                [switch]$del_old_dir,
				[switch]$logs_ashtml,
                [switch]$asuppercase
              )     
        $stringsaida = ""
        if ($del_old_dir)
            {
                if (Test-Path -Path $dirtocreate)
                    {
                        remove-item -recurse $dirtocreate | Out-Null
						$stringsaida = "Diretório $dirtocreate removido."
						if($logs_ashtml)
							{$stringsaida += "<br>"}
						else
							{$stringsaida += "`n"}
                    }         
            }
        if (!(Test-Path -Path $dirtocreate))
            {
                $stringsaida += "Diretório $dirtocreate criado." 
                New-Item -Path $dirtocreate -ItemType Directory | Out-Null
            }
        else
            {$stringsaida = "Diretório $dirtocreate já existe." }
        if($logs_ashtml)
            {$stringsaida += "<br>"}
		else
			{$stringsaida += "`n"}
        if($asuppercase)
            {$stringsaida = $stringsaida.ToUpper()}
        Write-Output $stringsaida
    }