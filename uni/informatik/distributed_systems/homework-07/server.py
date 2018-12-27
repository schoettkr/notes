#!/usr/bin/env python

import asyncio
import websockets

sockets = []

# Note: doesnt work across refresh right now so you need to start the server, open both html pages and then it works, if you refresh it doesnt because connection is not properly closed on server side but I dont have time to implement right now :P

async def handler(websocket, path):
    sockets.append(websocket)
    async for message in websocket:
        for socket in sockets:
            await socket.send(message)

start_server = websockets.serve(handler, 'localhost', 8765)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()


