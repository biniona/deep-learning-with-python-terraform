c = get_config()  # noqa
c.NotebookApp.certfile = u'/home/ubuntu/ssl/cert.pem'
c.NotebookApp.keyfile = u'/home/ubuntu/ssl/cert.key'
c.IPKernelApp.pylab = 'inline'
c.NotebookApp.ip = '*'

c.NotebookApp.open_browser = False
c.NotebookApp.password = 'A HASH OF YOUR PASSWORD'