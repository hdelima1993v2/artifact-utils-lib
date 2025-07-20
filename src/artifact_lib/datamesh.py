from datetime import datetime
import awswrangler as wr
import pandas as pd 
import os

def ingest_expenses_sor(df: pd.DataFrame, user: str) -> dict:
    """
    Função responsável por preencher a tabela despesas_sor de acordo com o 
    banco de dados que o usuário está executando

    :param df: dataframe com os gastos que serão inseridos na tabela.
    :param user: usuário que está executando a aplicação.
    
    :return: dicionário com a quantidade de linhas inseridas na tabela.
    """
    try:
        database = 'db_source_expenses_' + user
        table = 'despesas_sor'
        for field in df.columns:
            df[field] = df[field].astype(str).replace({'nan': None, 'NaT':None, 
                'None': None})

        # Escrever (append)
        wr.s3.to_parquet(
            df=df, 
            path=f's3://ddd-dbsource-datamesh/{database}/{table}/',
            dataset=False,
            database=database,
            table=table,
            mode="append"
        )

        return {"linhas_gravadas": len(df)}
    
    except Exception as e:
        raise Exception('[datamesh.ingest_expenses_sor] erro ao inserir dados'
            f' na tabela:{e}')
