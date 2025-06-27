function conv_base64 
	{
		<#
			.SYNOPSIS
				Codifica ou decodifica uma string em Base64.
		
			.DESCRIPTION
				Esta função permite converter uma string para Base64 (ofuscar) ou
				converter uma string Base64 de volta para sua forma original (desofuscar).
		
			.PARAMETER stringentra
				A string a ser processada. Se for para codificar, é a string original.
				Se for para decodificar, é a string codificada em Base64.
		
			.PARAMETER action_type
				Define a operação a ser realizada. Use 'Encode' para codificar para Base64
				ou 'Decode' para decodificar de Base64. O valor padrão é 'Encode'.
		
			.EXAMPLE
				# Codificar uma string
				conv_base64 -stringentra "STRING QUALQUER" -action_type Encode
				# Saída: <STRING BASE64>
		
			.EXAMPLE
				# Decodificar uma string Base64
				conv_base64 -stringentra "<STRING BASE64>" -action_type Decode
				# Saída: STRING QUALQUER
				
			.NOTES
				Desenvolvido por Flavio Galvão
				GitHub: https://github.com/frigerigalvao/funcoes-powershell
				Versão: 1.0
				Data: 2025-06-27
				Licença: MIT License
				Requisitos: 
			#>
			
		[CmdletBinding()]
		Param
			(
				[string]$stringentra,
				[string]$action_type = 'Encode'
			)

		if ($action_type -eq 'Encode') 
			{
				# Converte a string de entrada para bytes usando UTF-8
				$stringsaida = [System.Text.Encoding]::UTF8.GetBytes($stringentra)
				# Converte os bytes para uma string Base64
				[System.Convert]::ToBase64String($stringsaida)
			}
		elseif ($action_type -eq 'Decode') 
			{
				# Converte a string Base64 para bytes
				$stringsaida = [System.Convert]::FromBase64String($stringentra)
				# Converte os bytes de volta para a string original usando UTF-8
				[System.Text.Encoding]::UTF8.GetString($stringsaida)
			}
	}