#!/usr/bin/env python

# Note: Ported the code to Python 3

import sys, socket

def create_error_page(conn, err_string):
    conn.send(b'HTTP/1.1 400 Bad Request\r\n')
    conn.send(b'Connection: close\r\n')
    conn.send(b'Content-Type: text/html\r\n\r\n')
    conn.send(b'<html><head><title>ERROR</title></head>\r\n')
    conn.send(bytes('<body><h1>Error</h1><hr/><p>%s</p></body></html>'%(err_string), 'utf-8'))
    conn.close()

def handleRequest(conn):
    data = conn.recv(1024)
    parts = data.split(b'\r\n\r\n')
    head = parts[0]
    body = ''
    if len(parts) > 1:
        body = parts[1]
    header = {}
    values = {}
    lines = head.split(b'\r\n')

    if lines[0].split(b' ')[1] != b'/':
        create_error_page(conn, "Resource not avaiable")
        return

    for line in lines[1:]:
        key, value = line.split(b': ')
        header[key] = value

    try:
        cookies = header[b'Cookie'].decode("utf-8").split("; ")
        for cookie in cookies:
            C = cookie.split("=")
            if C[0] == 'kontostand':
                kontostand = float(C[1])
    except:
        kontostand = 999.00


    if body:
        pairs = body.split(b'&')
        for pair in pairs:
            key, value = pair.split(b'=')
            values[key] = value


    if b'amount' in values:
        try:
            amount = float(values[b'amount'])
        except:
            create_error_page(conn, (values[b'amount'].decode() + " ist kein Fliesskommawert"))
            return

        kontostand -= amount

    conn.send(b'HTTP/1.1 200 OK\r\n')
    conn.send(b'Connection: close\r\n')
    conn.send(b'Set-Cookie: kontostand=%5.2f\r\n;'%(kontostand))
    conn.send(b'Content-Type: text/html\r\n\r\n')
    conn.send(b'<html><head><title>Konto</title></head>\r\n')
    conn.send(b'<body><h1>Konto</h1><hr/>\r\n')
    if b'amount' in values:
        conn.send(bytes('<p>Ueberwiesen = %5.2f</p>\r\n'%(amount), 'utf-8'))
    conn.send(bytes('<p>Neuer Kontostand = %5.2f</p>\r\n'%(kontostand), 'utf-8'))
    conn.send(b'<form method="POST" action="/" enctype="application/x-www-form-urlencoded">\r\n')
    conn.send(bytes('<p>Betrag zum Ueberweisen: <input type="text" required name="amount"/></p>\r\n', 'utf-8'))
    conn.send(bytes('<p><input type="submit" value="Abschicken"/></p>\r\n', 'utf-8'))
    conn.send(b'</form>\r\n')
    conn.send(b'</body></html>\r\n')
    conn.close()
    return

KONTOSTANDFILE = 'konto.txt'

TCP_IP = ''
TCP_PORT = 5000

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind((TCP_IP, TCP_PORT))
s.listen(1)

while 1:
    conn, addr = s.accept()
    handleRequest(conn)
