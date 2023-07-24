import sys
import queue
import multiprocessing
from PyQt5.QtCore import Qt, QThread, pyqtSignal
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QLabel
import atexit


# queue handler listens for data on queue on
# a seperate thread forever and sets it to label
class QueueListener(QThread):
    # this signal is connected to main app update text method
    update_signal = pyqtSignal(str)

    def __init__(self, queue):
        super().__init__()
        self.queue = queue

    def run(self):
        while True:
            if not self.queue.empty():
                item = self.queue.get()
                self.update_signal.emit(item)


class MyApp(QWidget):
    def __init__(self, queue):
        super().__init__()
        self.queue = queue
        self.setWindowTitle("Queue Listener App")
        layout = QVBoxLayout()

        self.label = QLabel()
        self.label.setAlignment(Qt.AlignCenter)
        self.label.setWordWrap(True)  # Set word wrap to display text on multiple lines
        layout.addWidget(self.label)

        font = self.label.font()  # Get the current font
        font.setPointSize(25)  # Set the desired font size
        self.label.setFont(font)  # Apply the modified font

        self.setLayout(layout)
        self.show()

    def update_text(self, text):
        self.label.setText(text)


def cleanup_subprocess(process):
    if process.is_alive():
        process.terminate()
        process.join()


def qapp_proc(queue):
    app = QApplication([])
    window = MyApp(queue)
    window.setFixedSize(800, 500)  # Set the width and height in pixels

    listener = QueueListener(queue)
    listener.update_signal.connect(window.update_text)
    listener.start()

    sys.exit(app.exec_())


def init_gui():
    queue_obj = multiprocessing.Queue()
    process = multiprocessing.Process(target=qapp_proc, args=(queue_obj,))
    atexit.register(cleanup_subprocess, process)

    process.start()

    return queue_obj, process
