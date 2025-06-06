function tam-arquivo 
	{
		<#
		.SYNOPSIS
			Obtém o tamanho e a data de última modificação de arquivos ou diretórios em formato legível.

		.DESCRIPTION
			Esta função calcula o tamanho de um arquivo ou de todo o conteúdo de um diretório,
			apresentando-o em unidades de medida legíveis (Bytes, KB, MB, GB, TB).
			Opcionalmente, pode-se incluir a data da última modificação e o caminho completo
			do item em questão para uma saída mais detalhada. A função é robusta e lida
			com a ausência de arquivos ou diretórios informados.

		.PARAMETER caminho_arq
			Especifica o caminho completo para o arquivo ou diretório que você deseja analisar.
			Este parâmetro é obrigatório.

		.PARAMETER texto_saida
			Define uma mensagem de texto opcional para prefixar a saída, ideal para
			personalizar a informação exibida quando apenas o tamanho do arquivo é relevante.

		.PARAMETER saida_detal
			Quando presente, este parâmetro switch formata a saída para incluir não apenas
			o tamanho, mas também a data/hora da última modificação e o caminho completo
			do arquivo ou diretório analisado.

		.PARAMETER logs_ashtml
			Quando presente, adiciona uma tag HTML `<br>` ao final da string de saída,
			útil para formatar logs que serão exibidos em contextos HTML.

		.PARAMETER asuppercase
			Quando presente, converte toda a string de saída para letras maiúsculas.

		.EXAMPLE
			PS C:\> tam-arquivo -caminho_arq "C:\Logs\app.log" -texto_saida "Tamanho do Log:"
			Tamanho do Log: O arquivo tem 1.25MB

		.EXAMPLE
			PS C:\> tam-arquivo -caminho_arq "D:\Backups\database.bak" -saida_detal
			D:\Backups\database.bak - Tamanho: 5.78GB - Ultima Escrita: 2023-10-26 14:30:00

		.EXAMPLE
			PS C:\> tam-arquivo -caminho_arq "C:\PastaDeExemplo"
			A pasta tem 450.70KB

		.EXAMPLE
			PS C:\> tam-arquivo -caminho_arq "C:\NonExistentFile.txt"
			Erro: O arquivo ou diretório 'C:\NonExistentFile.txt' não foi encontrado.

		.NOTES
			Desenvolvido por: Flavio Galvão
			GitHub: https://github.com/frigerigalvao/funcoes-powershell
			Versão: 1.0
			Data de Criação: 2025-06-03
			Licença: MIT License (https://opensource.org/licenses/MIT)
		#>
		
		[CmdletBinding()]
		param 
				(
					[Parameter(Mandatory=$true, Position=0)]
					[string]$caminho_arq,
					[string]$texto_saida,
					[switch]$saida_detal,
					[switch]$logs_ashtml, 
					[switch]$asuppercase
				)
		$tam_em_byte = 0
		$ult_escrita = $null

		# Verifica se o caminho é um arquivo
		if (Test-Path -Path $caminho_arq -PathType Leaf) 
			{
				$info_do_arq = Get-Item $caminho_arq
				$tam_em_byte = $info_do_arq.Length
				$ult_escrita = $info_do_arq.LastWriteTime
				$e_diretorio = $false
			}
			# Verifica se o caminho é um diretório
		elseif (Test-Path -Path $caminho_arq -PathType Container) 
			{
				# Calcula o tamanho total do diretório recursivamente
				$tam_em_byte = (Get-ChildItem -Path $caminho_arq -Recurse -File | Measure-Object -Property Length -Sum).Sum
				# Aqui, vamos pegar a data do próprio diretório para consistência, mas o foco é o tamanho.
				$ult_escrita = (Get-Item $caminho_arq).LastWriteTime
				$e_diretorio = $true
			}
		else 
			{Write-output "Erro: O arquivo ou diretório '$caminho_arq' não foi encontrado."}

		$tam_legivel = ""
		$unid_medida = ""

		if ($tam_em_byte -ge 1TB) 
			{
				$tam_legivel = ($tam_em_byte / 1TB).ToString('N2')
				$unid_medida = "TB"
			} 
		elseif ($tam_em_byte -ge 1GB) 
			{
				$tam_legivel = ($tam_em_byte / 1GB).ToString('N2')
				$unid_medida = "GB"
			} 
		elseif ($tam_em_byte -ge 1MB) 
			{
				$tam_legivel = ($tam_em_byte / 1MB).ToString('N2')
				$unid_medida = "MB"
			} 
		elseif ($tam_em_byte -ge 1KB) 
			{
				$tam_legivel = ($tam_em_byte / 1KB).ToString('N2')
				$unid_medida = "KB"
			} 
		else 
			{
				$tam_legivel = $tam_em_byte.ToString()
				$unid_medida = "Bytes"
			}

		if ($e_diretorio) 
			{$stringsaida = "A pasta tem"}
		else
			{$stringsaida = "O arquivo tem"}
		
		if ($saida_detal) 
			{
				if ($texto_saida -eq "")
					{$stringsaida = "$caminho_arq - Tamanho: $tam_legivel$unid_medida - Ultima Escrita: $($ult_escrita.ToString('yyyy-MM-dd HH:mm:ss'))" }
				else
					{$stringsaida = "$caminho_arq - Tamanho: $tam_legivel$unid_medida - Ultima Escrita: $($ult_escrita.ToString('yyyy-MM-dd HH:mm:ss')) - $texto_saida" }
			}
		else 
			{
				if ($texto_saida) 
					{$stringsaida = "$texto_saida - $stringsaida $tam_legivel$unid_medida"} 
				else 
					{$stringsaida = "$stringsaida $tam_legivel$unid_medida"}
			}
		
		if ($logs_ashtml) 
			{$stringsaida = "$stringsaida<br>"}
		
		if ($asuppercase) 
			{$stringsaida = $stringsaida.ToUpper()}
		Write-Output $stringsaida
	}