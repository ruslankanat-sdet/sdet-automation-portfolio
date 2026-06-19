"""Store API contract checks against seeded demo data.

This is the start of the wide pyramid base — fast, deterministic REST checks.
v2 layers cart lifecycle, checkout/order creation, and negative cases here.
"""
import pytest


@pytest.mark.smoke
def test_store_lists_products(session, base_url, publishable_key):
    if not publishable_key:
        pytest.skip("MEDUSA_PUBLISHABLE_KEY not set; /store routes need a publishable key")

    resp = session.get(f"{base_url}/store/products", timeout=10)
    assert resp.status_code == 200

    body = resp.json()
    assert "products" in body and isinstance(body["products"], list)
    assert body["products"], "seeded SUT should expose at least one product"


def test_store_rejects_request_without_publishable_key(base_url):
    """Negative case: store routes must reject a request with no publishable key."""
    import requests

    resp = requests.get(f"{base_url}/store/products", timeout=10)
    assert resp.status_code in (400, 401, 403)
