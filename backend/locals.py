import threading

# threading locals: it creates a nice global variable setter for the
# whole thread to be used everywhere in the current Thread
local = threading.local()
