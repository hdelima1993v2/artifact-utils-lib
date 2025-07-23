from artifact_lib.datamesh import ingest_expenses_sor
from unittest.mock import patch, MagicMock
import pandas as pd
import logging
import pytest
import time


logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

@patch('artifact_lib.datamesh.wr', MagicMock())
def test_ingest_expenses_sor(mock_dataframe):
    df = pd.DataFrame(mock_dataframe)
    version = int(time.time())
    df['numero_versao_processamento'] = version
    user = "thorfin"

    result = ingest_expenses_sor(df, user)
    logger.info(f'teste efetuado! Versão:{version}')
    assert result == {"linhas_gravadas": len(df)}

@patch('artifact_lib.datamesh.wr', MagicMock())
def test_except_ingest_expenses_sor(mock_dataframe):
    user = "thorfin"
    version = int(time.time())
    with pytest.raises(Exception) as error:
        result = ingest_expenses_sor(mock_dataframe, user)
    
    assert ('[datamesh.ingest_expenses_sor] erro ao inserir dados' in
             str(error.value))