class SingletonCreateMixin:

    _instances = {}

    @classmethod
    def create(cls):
        if cls not in cls._instances:
            cls._instances[cls] = cls()
        return cls._instances[cls]
