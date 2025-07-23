from pytest import fixture
import logging
import pytest

@pytest.fixture(autouse=True)
def add_testname_to_logs(request):
    testname = request.node.nodeid  # ex: tests/test_datamesh.py::test_ingest_expenses_sor
    root = logging.getLogger()

    def _filter(record):
        record.testname = testname
        return True

    for h in root.handlers:
        h.addFilter(_filter)
    yield
    for h in root.handlers:
        h.removeFilter(_filter)

@fixture
def mock_dataframe():
    return [
        {
            'data': '01/04/2025', 
            'lancamento': 'REND PAGO APLIC AUT MAIS', 'valor': '0,11', 
            'despesa': 'debito', 
            'anomes': '202504'
        }, 
        {
            'data': '01/04/2025',
            'lancamento': 'ITAU MC       4501-1816', 
            'valor': '-5746,68', 
            'despesa': 'debito', 
            'anomes': '202504'
        }, 
        {
            'data': '02/04/2025', 
            'lancamento': 'CREDITO LIBERAD PIX 6261', 
            'valor': '310,00', 
            'despesa': 'debito', 
            'anomes': '202504'
        }, 
        {
            'data': '02/04/2025', 
            'lancamento': 'PIX CARTAO PatrÃ\x83Â\xadcia Ha02/04', 
            'valor': '-310,00', 
            'despesa': 'debito', 
            'anomes': '202504'
        }, 
        {
            'data': '02/04/2025', 
            'lancamento': 'RSCSS PAYGO AGUA P0204 PAYGO*AGUA PURA DIS', 
            'valor': '-18,00', 
            'despesa': 'debito', 
            'anomes': '202504'
        }, 
        {
            'data': '02/04/2025', 
            'lancamento': 'RSCSS VEND PERTO M0204 VEND PERTO MACHINES', 
            'valor': '-21,51', 
            'despesa': 'debito', 
            'anomes': '202504'
        }, 
        {
            'data': '03/04/2025', 'lancamento': 
            'RSCSS CAFE MANIA  0304 CAFE MANIA', 
            'valor': '-23,00', 
            'despesa': 'debito', 
            'anomes': '202504'
        }, 
        {
            'data': '03/04/2025', 
            'lancamento': 'RSCSS SPTRANS PMB 0304 SPTRANS PMB*Descriptio', 
            'valor': '-5,00', 
            'despesa': 'debito', 
            'anomes': '202504'
        }, 
        {
            'data': '03/04/2025', 
            'lancamento': 'PIX TRANSF LEIA CR03/04', 
            'valor': '-200,00', 
            'despesa': 'debito', 
            'anomes': '202504'
        }, 
        {
            'data': '03/04/2025', 
            'lancamento': 'RSCSS HIROTA FOOD 0304 HIROTA FOOD EXPRESS IT', 
            'valor': '-13,96', 
            'despesa': 'debito', 
            'anomes': '202504'
        }
    ]