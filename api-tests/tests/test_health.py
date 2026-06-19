"""v1 smoke: the SUT is up and serving. Gates everything else."""
import pytest


@pytest.mark.smoke
def test_backend_is_healthy(session, base_url):
    resp = session.get(f"{base_url}/health", timeout=10)
    assert resp.status_code == 200
