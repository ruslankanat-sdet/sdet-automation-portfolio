"""Shared fixtures for the API suite.

The SUT location and credentials are injected via environment variables so the
same suite runs unchanged locally and in CI. Nothing here is hard-coded to a
single environment — that is the whole point of owning the SUT.
"""
import os

import pytest
import requests


@pytest.fixture(scope="session")
def base_url() -> str:
    return os.environ.get("SUT_BASE_URL", "http://localhost:9000")


@pytest.fixture(scope="session")
def publishable_key() -> str | None:
    """Medusa Store API routes require a publishable API key header.

    Seeded into the SUT and exposed to the suite via env. When absent, store
    tests skip rather than fail — a missing key is a config gap, not a defect.
    """
    return os.environ.get("MEDUSA_PUBLISHABLE_KEY")


@pytest.fixture(scope="session")
def session(publishable_key: str | None) -> requests.Session:
    s = requests.Session()
    if publishable_key:
        s.headers.update({"x-publishable-api-key": publishable_key})
    return s
