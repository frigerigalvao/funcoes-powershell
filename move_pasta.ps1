function mover_itens
	{
		<#
			.SYNOPSIS
				Move arquivos e/ou pastas de um local para outro.
				
			.DESCRIPTION
				Esta função move um item (arquivo ou pasta) de um caminho de origem
				para um caminho de destino. Inclui opções para forçar a operação,
				gerar logs em HTML e formatar a saída.
				
			.PARAMETER item_to_mov
				Caminho completo do arquivo ou pasta a ser movido.
				
			.PARAMETER destinoitem
				Caminho completo para o destino do item.
				
			.PARAMETER this_folder
				Use esta chave se o item a ser movido for uma pasta.
				
			.PARAMETER logs_ashtml
				Use esta chave para formatar as mensagens de saída para HTML (adiciona <br>).
				
			.PARAMETER asuppercase
				Use esta chave para converter as mensagens de saída para letras maiúsculas.
			
			.EXAMPLE
				mover_itens -item_to_mov "C:\Origem\meuarquivo.txt" -destinoitem "D:\Destino\"
				Descrição: Move o arquivo 'meuarquivo.txt' da pasta 'C:\Origem\' para 'D:\Destino\'.
			
			.EXAMPLE
				mover_itens -item_to_mov "C:\MinhaPastaAntiga" -destinoitem "D:\NovaLocalizacao\" -this_folder
				Descrição: Move a pasta 'MinhaPastaAntiga' (e todo o seu conteúdo) de 'C:\' para 'D:\NovaLocalizacao\'.
			
			.EXAMPLE
				mover_itens -item_to_mov "C:\Relatorios\dados.xlsx" -destinoitem "D:\Backup\" -ForceOverride -logs_ashtml
				Descrição: Move o arquivo 'dados.xlsx' para 'D:\Backup\', forçando a sobrescrita caso já exista um arquivo com o mesmo nome no destino. A saída da operação será formatada em HTML.
			
			.EXAMPLE
				mover_itens -item_to_mov "C:\LogsDiarios" -destinoitem "E:\ArquivosMortos\" -this_folder -asuppercase
				Descrição: Move a pasta 'LogsDiarios' para 'E:\ArquivosMortos\'. A mensagem de saída será exibida em letras maiúsculas.
        
			.NOTES
				Desenvolvido por Flavio Galvão
				GitHub: https://github.com/frigerigalvao/funcoes-powershell
				Versão: 1.0
				Data: 2025-07-02
				Licença: MIT License
				Requisitos: Parâmetros corretamente informados
		#>
		
		param 
			(
				[string]$item_to_mov,
				[string]$destinoitem,
				[switch]$this_folder,
				[switch]$logs_ashtml,
				[switch]$asuppercase
			)
		if ([string]::IsNullOrWhiteSpace($item_to_mov)) 
			{
				Write-Output "Falta Parametro: -item_to_mov (Caminho completo do arquivo/pasta a ser movido)"
				exit 1
			}
		elseif ([string]::IsNullOrWhiteSpace($destinoitem))
			{
				Write-Output "Falta Parametro: -destinoitem (Caminho completo do destino)"
				exit 1
			}
		
		$stringsaida = ""
		$arqv_existe = Test-Path -Path $item_to_mov
		$dest_existe = Test-Path -Path $destinoitem
		
		if ($this_folder)
			{
				if (!$arqv_existe)
					{$stringsaida = "Diretorio de origem $item_to_mov nao existe"}
				else
					{
						move-item -path $item_to_mov -Destination $destinoitem -force
						$stringsaida = "Diretorio $item_to_mov movido para $destinoitem"
					}
			}
		else
			{
				if (!$arqv_existe)
					{$stringsaida = "Diretorio de origem $destinoitem nao existe"}
				elseif (!$dest_existe)
					{$stringsaida = "Diretorio de destino $destinoitem nao existe"}
				else
					{
						move-item -path $item_to_mov -Destination $destinoitem -force
						$stringsaida = "Arquivo(s) $item_to_mov movido(s) para $destinoitem"
					}
			}
		if($logs_ashtml)
			{$stringsaida += "<br>"}
		else
			{$stringsaida += "`n"}
		if($asuppercase)
			{$stringsaida = $stringsaida.ToUpper()}   
		Write-Output $stringsaida
	}