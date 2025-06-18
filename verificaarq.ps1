function verificaarq
	{
		    <#
				.SYNOPSIS
					Verifica a existência de um arquivo e, opcionalmente, o remove.
			
				.DESCRIPTION
					Esta função verifica se um arquivo específico existe no caminho fornecido.
					Dependendo dos parâmetros de switch, ela pode remover o arquivo se ele existir
					e formatar a string de saída para logs HTML ou texto plano, além de convertê-la para maiúsculas.
			
				.PARAMETER arq_to_veri
					Caminho completo (incluindo nome do arquivo e extensão) do arquivo a ser verificado.
					Este parâmetro é obrigatório.
			
				.PARAMETER del_old_arq
					Quando presente, se o arquivo especificado por -arq_to_veri existir, ele será removido.
					Use com cautela, pois esta ação é irreversível.
			
				.PARAMETER logs_ashtml
					Quando presente, a quebra de linha na string de saída será "<br>" (para uso em HTML).
					Caso contrário, a quebra de linha será "`n" (para console ou texto plano).
			
				.PARAMETER asuppercase
					Quando presente, a string de saída final da função será convertida para letras maiúsculas.
					
				.PARAMETER output_type
					Quando presente, a função retorna um valor booleano ($true se o arquivo existe, $false caso contrário)
					em vez de uma string formatada.
		
				.INPUTS
					Nenhum. A função recebe entrada apenas através de seus parâmetros.
			
				.OUTPUTS
					System.String ou System.Boolean
						A função retorna uma string informando o status da verificação do arquivo
						(ex: "Arquivo não existe", "Arquivo removido", "Arquivo pronto para uso")
						ou um booleano se o parâmetro -ReturnBoolean for usado.
						
				.EXAMPLE
					verificaarq -arq_to_veri "C:\Logs\RelatorioDiario.log"
					Descrição: Verifica se o arquivo "C:\Logs\RelatorioDiario.log" existe e retorna seu status.
			
				.EXAMPLE
					verificaarq -arq_to_veri "C:\Backup\AntigoBackup.zip" -del_old_arq
					Descrição: Verifica se o arquivo "C:\Backup\AntigoBackup.zip" existe e, se sim, o remove.
			
				.EXAMPLE
					verificaarq -arq_to_veri "C:\Web\index.html" -logs_ashtml -asuppercase
					Descrição: Verifica o arquivo "C:\Web\index.html", formata a saída com <br>
						e converte a mensagem final para maiúsculas.
			
				.EXAMPLE
					verificaarq -arq_to_veri ""
					Descrição: Demonstra a saída quando o parâmetro obrigatório está ausente ou vazio.
						Isso fará com que a função saia com um código de erro.
						
				.NOTES
					Desenvolvido por Flavio Galvão
					GitHub: https://github.com/frigerigalvao/funcoes-powershell
					Versão: 1.0
					Data: 2025-06-03
					Licença: MIT License
					Requisitos: nenhum
			#>
        param 
                (
                    [string]$arq_to_veri,
                    [switch]$del_old_arq,  
					[switch]$output_type,					
                    [switch]$logs_ashtml,
                    [switch]$asuppercase
					
                )
		if ([string]::IsNullOrWhiteSpace($arq_to_veri)) 
            {
                Write-Output "Falta Parametro: -arq_to_veri (Caminho completo do arquivo a ser verificado)"
                exit 1
            }
		$stringsaida = ""	
		$arqv_existe = Test-Path -Path $arq_to_veri
        if (!$arqv_existe)
            {$stringsaida = "Arquivo $arq_to_veri não existe"}
        elseif ($del_old_arq)
            {
                Remove-Item $arq_to_veri | Out-Null
                $stringsaida = "Arquivo $arq_to_veri removido"
            }
        else
            {$stringsaida = "Arquivo $arq_to_veri pronto para uso"}
        if($logs_ashtml)
            {$stringsaida += "<br>"}
        else
            {$stringsaida += "`n"}
        if($asuppercase)
            {$stringsaida = $stringsaida.ToUpper()}   
		if ($output_type)
			{return $arqv_existe}
		else
			{Write-Output $stringsaida}
    }