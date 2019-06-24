import socket
import os
import threading
import sys

from contextlib import contextmanager

@contextmanager
def managed_conn(conn):
    try:
        yield conn
    finally:
        conn.close()

MSG_SIZE = 4
def service_conn(conn):
    with managed_conn(conn) as c:
        c.recv(MSG_SIZE)

def server(server_address='./de-mon.sock'):
    try:
        os.unlink(server_address)
    except OSError:
        if os.path.exists(server_address):
            raise

    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.bind(server_address)

    while True:
        conn, _ = sock.accept()
        conn_thread = threading.Thread(target=service_conn, args=(conn,))
        conn_thread.set_daemon(True)
        conn_thread.start()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
            description="Manages various services that build up my desktop"\
                    "environment.")
    parser.add_argument('-r', '--register', )# todo register a service given a config
    parser.add_argument('-l', '--list', )#list all managed services
    parser.add_argument('-R', '--restart',)# restart a service
    parser.add_argument('-S', '--stop', )# stop a service

