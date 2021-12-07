#!/usr/bin/python3

from huawei_lte_api.Client import Client
from huawei_lte_api.Connection import Connection

with Connection('http://admin:okxijinping@192.168.69.1/') as connection:
    client = Client(connection)

    print(client.device.reboot())


# For more API calls just look on code in the huawei_lte_api/api folder, there is no separate DOC yet
