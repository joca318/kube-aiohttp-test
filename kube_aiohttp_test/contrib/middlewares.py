import logging

from aiohttp import web

from kube_aiohttp_test.contrib.exceptions import APIException
from kube_aiohttp_test.contrib.response import JSONResponse
from kube_aiohttp_test.version import __version__

logger = logging.getLogger(__name__)


@web.middleware
async def exception_handler_middleware(request, handler):

    try:
        return await handler(request)

    except APIException as exc:
        return JSONResponse(data=exc.as_dict(), status=exc.status_code)

    except web.HTTPError as exc:
        logger.exception(
            f'Unknow error for request {request.url.path}. Exception: {exc}'
        )
        data = {'error_code': 'unexpected_error', 'error_message': exc.reason}
        return JSONResponse(data=data, status=exc.status_code)

    except Exception as exc:
        logger.exception(
            f'Unknow error for request {request.url.path}. Exception: {exc}'
        )
        data = {
            'error_code': 'unexpected_error',
            'error_message': 'Internal server error'
        }
        return JSONResponse(data=data, status=500)


@web.middleware
async def version_middleware(request, handler):
    response = await handler(request)
    response.headers['X-API-Version'] = __version__
    return response
