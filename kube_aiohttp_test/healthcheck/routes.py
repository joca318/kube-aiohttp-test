from .views import HealthCheckView, SleepView, ExternalRequestView


def register_routes(app):
    app.router.add_route('*', '/healthcheck/', HealthCheckView)
    app.router.add_route('*', '/sleep/', SleepView)
    app.router.add_route('*', '/external/', ExternalRequestView)
