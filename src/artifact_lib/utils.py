from dateutil.relativedelta import relativedelta
import pandas as pd


def get_dateref_yyyymm(df: pd.DataFrame, date_column:str,
                        format_field:str, sell_type: str)-> str:
    """
    Identifica a data referência em uma coluna de um DataFrame pandas e retorna
    o ano e o mês no formato YYYYMM.

    :param df: DataFrame contendo a coluna de datas.
    :param date_column: Nome da coluna que contém as datas.
    :param format_field: formato da data que o campo possuí. 
    :param sell_type: tipo de despesa do arquivo.
    
    :return str: ano mês min/max no formato YYYYMM.
    """
    try:
        # Converte a coluna para datetime, se ainda não for
        df[date_column] = pd.to_datetime(
                            df[date_column], 
                            format=format_field,
                            errors='coerce')
        
        # Encontra a data máxima e retorna no formato desejado
        if sell_type == 'debito':
            dateref = df[date_column].min()

        if sell_type == 'credito':
            dateref = df[date_column].max()
            dateref = dateref + relativedelta(months=1)

        return dateref.strftime('%Y%m') if pd.notnull(dateref) else None
    
    except Exception as e:
            raise Exception('[utils - functions.get_dateref_yyyymm] Erro ao '
                f'capturar o dataref da tabela: (Tipo:{sell_type}, erro:{e})')
