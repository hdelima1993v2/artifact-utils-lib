from artifact_lib.utils import get_dateref_yyyymm
import pandas as pd
import pytest

def test_get_dateref_yyyymm_debito(mock_dataframe):
    df = pd.DataFrame(mock_dataframe)
    result = get_dateref_yyyymm(df, "data", "%d/%m/%Y","debito")
    assert result == "202504"

def test_get_dateref_yyyymm_credito(mock_dataframe):
    df = pd.DataFrame(mock_dataframe)
    result = get_dateref_yyyymm(df, "data", "%d/%m/%Y","credito")
    assert result == "202505"

def test_except_ingest_expenses_sor(mock_dataframe):
    with pytest.raises(Exception) as error:
        result = get_dateref_yyyymm(mock_dataframe,"data", "%d/%m/%Y","debito")    
    assert ('Erro ao capturar o dataref da tabela' in str(error.value))