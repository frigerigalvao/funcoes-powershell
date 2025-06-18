function hora-motivo 
	{
		<#
		.SYNOPSIS
			Apresenta um text_motivo seguido da hora atual com opções de formatação.

		.DESCRIPTION
			Esta função formata uma string contendo um text_motivo e a data/hora atual.
			Pode ser configurada para saída em HTML e para ter o texto em maiúsculas.

		.PARAMETER text_motivo
			O texto que representa o text_motivo a ser exibido.
			Se não fornecido, o padrão é "Executando" seguido da data e hora.

		.PARAMETER logs_ashtml
			Use este switch para indicar que a saída deve incluir uma quebra de linha HTML (<BR>),
			útil para e-mails em HTML.

		.PARAMETER asuppercase
			Use este switch para converter o text_motivo e a data/hora para letras maiúsculas.

		.EXAMPLE
			hora-motivo -text_motivo "Backup Concluído"
			# Saída: Backup Concluído Terça-feira 03-06-2025 10:25:27

		.EXAMPLE
			hora-motivo -text_motivo "Relatório Gerado" -logs_ashtml
			# Saída: Relatório Gerado Terça-feira 03-06-2025 10:25:27<BR>

		.EXAMPLE
			hora-motivo -text_motivo "Início do Processo" -asuppercase
			# Saída: INÍCIO DO PROCESSO TERÇA-FEIRA 03-06-2025 10:25:27

		.EXAMPLE
			hora-motivo -text_motivo "Tarefa Finalizada" -logs_ashtml -asuppercase
			# Saída: TAREFA FINALIZADA TERÇA-FEIRA 03-06-2025 10:25:27<BR>
			
		.NOTES
			Desenvolvido por Flavio Galvão
			GitHub: https://github.com/frigerigalvao/funcoes-powershell
			Versão: 1.0
			Data: 2025-06-18
			Licença: MIT License
		#>
		param 
				(
					[string]$text_motivo, 
					[switch]$logs_ashtml,
					[switch]$asuppercase
				)
		### OBTÉM A DATA E HORA FORMATADA
		$stringsaida = Get-Date -UFormat "%A %d-%m-%Y %H:%M:%S"
		### DEFINE O TEXT_MOTIVO PADRÃO SE NÃO FOR FORNECIDO
		if ([string]::IsNullOrEmpty($text_motivo)) 
			{$stringsaida = "Executando em " + $stringsaida}
		else
			{$stringsaida = $text_motivo + " " + $stringsaida}
		### ADICIONA A QUEBRA DE LINHA HTML SE O SWITCH ESTIVER PRESENTE
		if ($logs_ashtml) 
			{$stringsaida +=  "<br>"}
		else
			{$stringsaida +=  "`n"}
		### APLICA A CONVERSÃO PARA MAIÚSCULAS SE O SWITCH ESTIVER PRESENTE
		if ($asuppercase) 
			{$stringsaida = $stringsaida.ToUpper()}
		Write-Output $stringsaida
	}