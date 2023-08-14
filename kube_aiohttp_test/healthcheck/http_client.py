import logging

import aiohttp
from simple_settings import settings

from .mixins import SingletonCreateMixin

logger = logging.getLogger(__name__)


class BaseHttpRequest(SingletonCreateMixin):

    def __init__(self):
        connector = aiohttp.TCPConnector(
            limit=50,
            limit_per_host=50
        )

        self.session = aiohttp.ClientSession(connector=connector)

    async def fetch(
        self,
        method,
        endpoint,
        headers=None,
        payload=None,
        timeout=None,
        params=None
    ):
        request_method = getattr(self.session, method)
        request_args = {'headers': headers}

        response = await request_method(
            endpoint,
            json=payload,
            timeout=10.0,
            params=params or {},
            **request_args
        )
        return response
