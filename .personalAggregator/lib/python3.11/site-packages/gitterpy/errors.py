class BaseGitterError(Exception):
    def __init__(self, room_name):
        self.room_name = room_name


class GitterApiError:
    pass


class GitterTokenError(Exception):
    def __init__(self, error='Please provide your token'):
        self.error = error

    def __str__(self):
        return self.error


class GitterMessageErorr(BaseGitterError):
    def __init__(self, room_name):
        super().__init__(room_name)

    def __str__(self):
        return 'You don\'t have messages in {} room'.format(self.room_name)


class GitterRoomError(BaseGitterError):
    def __init__(self, room_name):
        super().__init__(room_name)

    def __str__(self): return 'Room {} not found'.format(self.room_name)


class GitterItemsError(BaseGitterError):
    def __init__(self, room_name):
        super().__init__(room_name)

    def __str__(self):
        return 'All messages in {} room marked as read'.format(self.room_name)
