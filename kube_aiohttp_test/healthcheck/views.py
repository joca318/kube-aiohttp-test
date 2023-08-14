import asyncio

from aiohttp import web

from .http_client import BaseHttpRequest


class HealthCheckView(web.View):

    async def get(self):
        return web.json_response(data={'status': 'OK'})


class SleepView(web.View):

    async def get(self):
        await asyncio.sleep(0.05)
        return web.json_response(data={'status': 'OK'})


class ExternalRequestView(web.View):

    async def get(self):
        backend = BaseHttpRequest.create()
        result = await backend.fetch(
            method='get',
            endpoint='https://www.google.com/',
        )
        status = 'OK' if result.status == 200 else 'NOK'
        return web.json_response(data={'status': status})
